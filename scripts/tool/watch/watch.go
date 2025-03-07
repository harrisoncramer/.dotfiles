package watch

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"strings"
	"time"

	"github.com/spf13/cobra"
)

// Port mapping for services
var portMap = map[string]int{
	"orchestration": 9001,
	"integrations":  3222,
	"supervisor":    3220,
	"compliance":    3223,
}

var endpointMap = map[string]string{
	"orchestration": "healthz",
	"integrations":  "healthz",
	"supervisor":    "healthz",
	"compliance":    "healthz",
}

// checkDockerService verifies if the service is running in Docker
func checkDockerService(service string) bool {
	cmd := exec.Command("docker", "ps", "--filter", fmt.Sprintf("name=%s", service), "--filter", "status=running", "--format", "{{.Names}}")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return false
	}
	return strings.TrimSpace(out.String()) != ""
}

// checkHealth sends an HTTP request to the service's `/healthz` endpoint
func checkHealth(port int, endpoint string) bool {
	url := fmt.Sprintf("http://localhost:%d/%s", port, endpoint)
	fmt.Println(url)
	resp, err := http.Get(url)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	return resp.StatusCode == 200
}

// updateTmuxStatus updates the tmux status-right with the current state
func updateTmuxStatus(passed int, failed int, failingServices []string) {
	statusMessage := fmt.Sprintf("#[bg=#252534]  #[fg=#98BB6C]%d ✔️", passed)
	if failed > 0 {
		statusMessage += fmt.Sprintf(" #[fg=#E82424]%d ✘", failed)
		for _, svc := range failingServices {
			statusMessage += fmt.Sprintf(" %s", svc)
		}
	}
	statusMessage += " #[bg=#252534,fg=#7E9CD8] %I:%M:%S"

	cmd := exec.Command("tmux", "set", "-g", "status-right", statusMessage)
	_ = cmd.Run() // Ignore errors for now
}

// watchLogs is the main logic for checking service logs
func watchLogs(cmd *cobra.Command, args []string) {
	services := args

	if len(services) == 0 {
		log.Fatal("Needs services")
	}

	for {
		var passed, failed int
		var failingServices []string

		for _, service := range services {
			port, exists := portMap[service]
			if !exists {
				fmt.Printf("Warning: No port mapping found for %s\n", service)
				failed++
				failingServices = append(failingServices, service)
				continue
			}

			endpoint, exists := endpointMap[service]
			if !exists {
				fmt.Printf("Warning: No endpoint mapping found for %s\n", service)
				failed++
				failingServices = append(failingServices, service)
				continue
			}

			if !checkDockerService(service) {
				failed++
				log.Printf("%s service not running", service)
				failingServices = append(failingServices, service)
				continue
			}

			if checkHealth(port, endpoint) {
				log.Printf("%s service healthy", service)
				passed++
			} else {
				log.Printf("%s service not healthy", service)
				failed++
				failingServices = append(failingServices, service)
			}
		}

		updateTmuxStatus(passed, failed, failingServices)

		time.Sleep(500 * time.Millisecond)
	}
}

var WatchCmd = &cobra.Command{
	Use:   "watch-logs <service_name> [<service_name> ...]",
	Short: "Watch service logs and update tmux status",
	Run:   watchLogs,
}
