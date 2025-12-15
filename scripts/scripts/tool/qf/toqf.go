package qf

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"sync"

	"github.com/spf13/cobra"
)

/* This tool captures errors from a Go test run and syncs them to the .qf directory */

type QuickfixEntry struct {
	File    string
	Line    string
	Message string
}

var (
	qfDir  string
	qfFile string
)

func processLines(lines []string) ([]QuickfixEntry, bool) {
	var entries []QuickfixEntry

	inErrorBlock := false
	hasFailure := false
	var currentEntry QuickfixEntry

	traceRegex := regexp.MustCompile(`Error Trace:\s+(.+):(\d+)`)
	errorRegex := regexp.MustCompile(`Error:\s+(.+)`)
	testFailRegex := regexp.MustCompile(`=== FAIL:`)

	for _, line := range lines {
		if testFailRegex.MatchString(line) {
			hasFailure = true
		}

		if matches := traceRegex.FindStringSubmatch(line); len(matches) > 2 {
			currentEntry = QuickfixEntry{}
			inErrorBlock = true

			currentEntry.File = matches[1]
			currentEntry.Line = matches[2]
			continue
		}

		if inErrorBlock {
			if matches := errorRegex.FindStringSubmatch(line); len(matches) > 1 {
				hasFailure = true
				errorMsg := strings.TrimSpace(matches[1])
				currentEntry.Message = errorMsg

				entries = append(entries, currentEntry)

				inErrorBlock = false
				currentEntry = QuickfixEntry{}
			}
		}
	}

	return entries, hasFailure
}

func processOutput(reader io.Reader) ([]QuickfixEntry, bool) {
	var lines []string
	scanner := bufio.NewScanner(reader)

	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)
		lines = append(lines, line)
	}

	return processLines(lines)
}

func streamAndCapture(reader io.Reader, writer io.Writer, lines *[]string, mu *sync.Mutex, wg *sync.WaitGroup) {
	defer wg.Done()

	scanner := bufio.NewScanner(reader)
	for scanner.Scan() {
		line := scanner.Text()

		_, _ = fmt.Fprintln(writer, line)

		mu.Lock()
		*lines = append(*lines, line)
		mu.Unlock()
	}
}

func writeQuickfixFile(entries []QuickfixEntry, hasFailure bool) error {
	if err := os.MkdirAll(qfDir, 0755); err != nil {
		return fmt.Errorf("failed to create directory %s: %v", qfDir, err)
	}

	qfPath := filepath.Join(qfDir, qfFile)
	file, err := os.Create(qfPath)
	if err != nil {
		return fmt.Errorf("failed to create quickfix file %s: %v", qfPath, err)
	}
	defer func() {
		err = file.Close()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Failed to close file: %v", err)
		}
	}()

	for _, entry := range entries {
		if entry.File != "" && entry.Line != "" && entry.Message != "" {
			_, _ = fmt.Fprintf(file, "%s:%s:0: %s\n", entry.File, entry.Line, entry.Message)
		}
	}

	if len(entries) > 0 {
		fmt.Fprintf(os.Stderr, "\033[31m\nWrote %d entries to %s\033[0m\n", len(entries), qfPath)
		os.Exit(1)
	} else if hasFailure {
		fmt.Fprintf(os.Stderr, "\033[33m\nFailure occurred running tests!\033[0m\n")
		os.Exit(1)
	} else {
		fmt.Fprintf(os.Stderr, "\033[32m\nTests passed!\033[0m\n")
	}

	return nil
}

func convertToQuickfix(cmd *cobra.Command, args []string) {
	var entries []QuickfixEntry
	var hasFailure bool

	if len(args) == 0 {
		entries, hasFailure = processOutput(os.Stdin)
	} else {
		command := args[0]
		cmdArgs := args[1:]

		execCmd := exec.Command(command, cmdArgs...)

		stdout, err := execCmd.StdoutPipe()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Failed to create stdout pipe: %v\n", err)
			os.Exit(1)
		}

		stderr, err := execCmd.StderrPipe()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Failed to create stderr pipe: %v\n", err)
			os.Exit(1)
		}

		if err := execCmd.Start(); err != nil {
			fmt.Fprintf(os.Stderr, "Failed to start command: %v\n", err)
			os.Exit(1)
		}

		var allLines []string
		var mu sync.Mutex
		var wg sync.WaitGroup

		wg.Add(2)
		go streamAndCapture(stdout, os.Stdout, &allLines, &mu, &wg)
		go streamAndCapture(stderr, os.Stderr, &allLines, &mu, &wg)

		wg.Wait()

		if err := execCmd.Wait(); err != nil {
			fmt.Fprintf(os.Stderr, "Command failed: %v\n", err)
		}

		entries, hasFailure = processLines(allLines)
	}

	if err := writeQuickfixFile(entries, hasFailure); err != nil {
		os.Exit(1)
	}
}

var TestToQuickfix = &cobra.Command{
	Use:   "qf [flags] [command] [args...]",
	Short: "Convert Go test errors to quickfix format",
	Long: `Convert Go test output to quickfix format that can be loaded into Neovim.
Can be used in two ways:

1. Run a command and capture its output:
   qf go test ./...

2. Process piped input:
   go test ./... | qf

The command captures Error Trace lines and formats them for easy navigation.`,
	Run: convertToQuickfix,
}

func init() {
	TestToQuickfix.Flags().StringVar(&qfDir, "dir", ".qf", "Directory to store quickfix files")
	TestToQuickfix.Flags().StringVar(&qfFile, "file", "test-errors.qf", "Quickfix filename")
}
