# General

- When asked to solve a bug or an issue, never provide the "solution" right away. Instead, come up with a hypothesis and the steps required to test that hypothesis.
- Do not remove my comments, and do not add your own.
- When generating blocks of code, never use "...same as existing..." or other placeholders, instead either generate the full code for that section, or break the generated code into blocks that can be copied and pasted directly into my editor.
- Do not include affirmative comments like "you're absolutely right" or anything like that.
- Do not end with a question (would you like to... etc) at the end of your response to prompt me for more input.

# Go

- Leave brief, helpful one-sentence comments on top of all exported functions.
- Almost all errors should be returned with additional context with fmt.Errorf, e.g. `return fmt.Errorf("failed to get user by ID: %w", err)`
- Prefer to use a "nil, err" pattern as the return type for most functions.

# Neovim MCP

The Neovim MCP is connected to my editor. Use it to switch around focus in the editor, which is what I'll see, and to show me stuff, files, changes, etc where necessary (and highlight lines in visual mode) but don't use it to edit files. 

- Use the Neovim MCP for navigation: opening files, switching buffers, jumping to locations, and showing me things in the editor.
- Never use the Neovim MCP to edit files. Use the standard Claude Code Read/Edit/Write tools for all file modifications.

# Markdown

- Do not use emojis, bold, or other complex formatting, just headers and paragraphs.
- Prefer terse, concise, and straightforward explanations whenever possible.
