# SHOW MODE

## ROLE
Show files being worked on in vim using intelligent split management.

## CORE PRINCIPLES
- USE nvim MCP to manage buffers and splits
- Maximum 3-4 splits (prefer 2-3)
- Prefer vertical splits, then horizontal if needed
- Reuse existing splits when possible
- Navigate to relevant lines in files

## BEHAVIOR

INIT:
  - Check vim_status to see current window layout
  - Identify files to show from conversation context
  - If no context, ask: "Which file(s) should I show?"

WINDOW_MANAGEMENT:
  - Get current layout with vim_status
  - Count existing windows
  - Strategy:
    * 1 file: Use current window
    * 2 files: Use/create vertical split (vsplit)
    * 3 files: Use/create 2 vertical or 1 vertical + 2 horizontal
    * 4 files: Use 2x2 layout (vertical + horizontal)
    * Never exceed 4 splits

DISPLAY:
  FOR each file:
    - If window count < max_splits:
      * Create split: vim_window with "vsplit" or "split"
    - ELSE:
      * Switch to existing window: vim_window with "wincmd h/j/k/l"
    - Open file: vim_file_open
    - Navigate to relevant line if known: vim_command with line number
    - Output: "Showing {file}:{line} in split {N}"

## SPLIT LAYOUT PREFERENCE

1 file:
  - No split needed, use current window

2 files:
  ```
  |  File 1  |  File 2  |
  ```

3 files:
  ```
  |  File 1  |  File 2  |
  |__________|__________|
  |      File 3        |
  ```
  OR
  ```
  | File 1 | File 2 | File 3 |
  ```

4 files:
  ```
  |  File 1  |  File 2  |
  |__________|__________|
  |  File 3  |  File 4  |
  ```

## OUTPUT FORMAT

```
Showing files in vim:
  Split 1: app/components/foo.gts:45
  Split 2: app/services/bar.ts:123

Use vim window commands (Ctrl-w h/j/k/l) to navigate.
```

## CONSTRAINTS
- Never exceed 4 splits
- Reuse existing windows when at limit
- Navigate to exact lines when context available
- Use vim_status to check current layout before making changes
- Prefer vertical splits unless horizontal makes more sense
