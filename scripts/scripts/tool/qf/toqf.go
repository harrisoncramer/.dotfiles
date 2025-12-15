package qf

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/spf13/cobra"
)

type QuickfixEntry struct {
	File    string
	Line    string
	Message string
}

var (
	qfDir  string
	qfFile string
)

// convertToQuickfix is the main logic for converting test output to quickfix format
func convertToQuickfix(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		fmt.Fprintf(os.Stderr, "Error: No command specified\n")
		os.Exit(1)
	}

	if err := os.MkdirAll(qfDir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create directory %s: %v\n", qfDir, err)
		os.Exit(1)
	}

	command := args[0]
	cmdArgs := args[1:]

	execCmd := exec.Command(command, cmdArgs...)
	execCmd.Stderr = execCmd.Stdout // Redirect stderr to stdout

	stdout, err := execCmd.StdoutPipe()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create stdout pipe: %v\n", err)
		os.Exit(1)
	}

	if err := execCmd.Start(); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to start command: %v\n", err)
		os.Exit(1)
	}

	scanner := bufio.NewScanner(stdout)
	var entries []QuickfixEntry

	inErrorBlock := false
	var currentEntry QuickfixEntry

	traceRegex := regexp.MustCompile(`Error Trace:\s+(.+):(\d+)`)
	errorRegex := regexp.MustCompile(`Error:\s+(.+)`)

	for scanner.Scan() {
		line := scanner.Text()

		fmt.Println(line)

		if matches := traceRegex.FindStringSubmatch(line); len(matches) > 2 {
			currentEntry = QuickfixEntry{}
			inErrorBlock = true

			currentEntry.File = matches[1]
			currentEntry.Line = matches[2]
			continue
		}

		if inErrorBlock {
			if matches := errorRegex.FindStringSubmatch(line); len(matches) > 1 {
				errorMsg := strings.TrimSpace(matches[1])
				currentEntry.Message = errorMsg

				entries = append(entries, currentEntry)

				inErrorBlock = false
				currentEntry = QuickfixEntry{}
			}
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "Error reading command output: %v\n", err)
		os.Exit(1)
	}

	if err := execCmd.Wait(); err != nil {
		fmt.Fprintf(os.Stderr, "Command failed: %v\n", err)
	}

	if len(entries) == 0 {
		return
	}

	qfPath := filepath.Join(qfDir, qfFile)
	file, err := os.Create(qfPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create quickfix file %s: %v\n", qfPath, err)
		os.Exit(1)
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

	fmt.Printf("\nWrote %d entries to %s\n", len(entries), qfPath)
}

var TestToQuickfix = &cobra.Command{
	Use:   "qf [flags] <command> [args...]",
	Short: "Run command and convert Go test errors to quickfix format",
	Long: `Run a command (typically go test) and parse its output to create a quickfix file
that can be loaded into Neovim. The command captures Error Trace lines and formats
them for easy navigation to test failures.

Examples:
  qf go test ./...
  qf --dir .quickfix --file errors.qf go test -v ./pkg/...`,
	Run: convertToQuickfix,
}

func init() {
	TestToQuickfix.Flags().StringVar(&qfDir, "dir", ".qf", "Directory to store quickfix files")
	TestToQuickfix.Flags().StringVar(&qfFile, "file", "test-errors.qf", "Quickfix filename")
}
