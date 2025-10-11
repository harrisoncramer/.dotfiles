package main

import (
	"fmt"
	"os"

	"github.com/harrisoncramer/tool/watch"
	"github.com/spf13/cobra"
)

func main() {
	var rootCmd = &cobra.Command{Use: "tool"}
	rootCmd.AddCommand(watch.WatchCmd)
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
