### 1. Edit Command Buffer
This hack allows you to open your current command line in a full text editor (like Neovim) to fix complex commands [3].
* **Implementation:** You must add **three specific lines** to your `.zshrc` file to enable the `edit-command-buffer` widget [3].
* **Keybinding:** The source suggests binding this to **`Ctrl-X` followed by `Ctrl-E`** [3].
* **Usage:** When you realize you made a mistake in a long command, hit the shortcut to fix it using your editor's keybindings. Once you save and exit, the corrected text returns to the terminal prompt [3].

### 2. Built-in Undo and Redo
Zshell has a built-in "Undo" feature for actions taken within the command buffer [4].
* **Undo Implementation:** Press **`Control + _` (underscore)** to undo the last action, such as an accidental deletion of text using `Ctrl+W` [4].
* **Redo Implementation:** Zshell has a "redo" widget (colloquially called "undo an undo"), but it does **not have a default keybinding** [4]. You would need to manually define a keybinding in your configuration to use it [4].

### 3. Magic Space Widget
This widget expands historical command references (like `!!`) into their full text immediately, preventing errors when running previous commands [4], [5].
* **Implementation:** Bind the **`magic-space`** widget to your **Space key** [5].
* **Expansion Examples:** It expands `!!` (previous command), references by index, or specific arguments from history [5].
* **Visual Confirmation:** Pressing space after `sudo !!` will show you exactly what command will be executed before you hit enter, which the source compares to avoiding "Russian roulette" [5].

### 4. The `chpwd` Hook
The `chpwd` hook executes functions automatically whenever you change your working directory [6].
* **Basic Implementation:** Define a `chpwd` function in your `.zshrc`. For example, adding `ls` inside the function will list directory contents every time you `cd` [6].
* **Advanced Management:** Since you can only define one `chpwd` function, the source recommends using the **`add-zsh-hook` widget** to manage multiple behaviors without bloating a single function [7].
* **Specific Use Cases:**
* **Nix:** Load a Nix develop shell if a `flake.nix` is present [7].
* **Python:** Automatically activate a virtual environment upon entering the folder [7].
* **Node.js:** Run `nvm use` if an `.nvmrc` file is detected [8].

### 5. Suffix Aliases
Suffix aliases trigger commands based on the **extension** of the file you type, allowing you to open files without typing a leading command [9], [10].
* **Implementation Command:** Use `alias -s =` [10].
* **Example:** `alias -s go=nvim` will open any file ending in `.go` in Neovim when you simply type the filename and hit enter [10].
* **Behavior:** These only trigger if no other command is specified, so you can still use `cat` or `rm` on those files normally [10].

### 6. Global Aliases
Unlike standard aliases that must be at the start of a line, global aliases expand **anywhere** in a command string [11].
* **Implementation Command:** Use the **`-g` flag**: `alias -g =''` [11], [12].
* **Example:** `alias -g NE='2>/dev/null'` allows you to append `NE` to any command to silence errors [12].
* **Best Practice:** The source suggests using **uppercase names** for global aliases to prevent accidental expansion of common words during normal typing [12].

### 7. ZMV for Batch Renaming
ZMV is a powerful tool for batch moving or renaming files using pattern matching [13].
* **Activation:** This is not enabled by default; you must add `autoload -U zmv` to your configuration [13].
* **Usage Syntax:** `zmv '(*).log' '$1.txt'` uses capture groups (the `*` inside parentheses) to reference parts of the original filename (as `$1`) in the new name [13], [14].
* **Safety Flags:**
* **`-n`**: Dry run mode to preview changes without executing them [14].
* **`-i`**: Interactive mode to prompt for confirmation for every change [14].
* **`-w`**: A simpler syntax flag for basic moves [14].

### 8. Named Directories (Bookmarks)
This feature allows you to create "bookmarks" for long file paths [15].
* **Implementation Command:** Use `hash -d =` [15].
* **Example:** `hash -d YT=/path/to/youtube/projects` [15].
* **Usage:** Reference the path using the **tilde symbol**: `cd ~YT` [15].

### 9. Custom ZLE Widgets
The Zshell Line Editor (ZLE) allows you to create custom functions that interact with the terminal buffer itself [16], [17].
* **Implementation Tool:** Use the `zle` command to define and bind these widgets [17].
* **Featured Custom Widgets:**
* **Clear History but Keep Buffer:** A widget bound to **`Ctrl-X` then `L`** that clears the screen but leaves your current un-executed command in the prompt [16], [17].
* **Copy to Clipboard:** A widget bound to **`Ctrl-X` then `Ctrl-C`** that copies everything currently in your command buffer to the system clipboard [17].

### 10. Boilerplate Insertion Hotkeys
You can create hotkeys that insert entire strings of text into your buffer and even position the cursor automatically [17], [18].
* **Implementation Command:** Use `bindkey -s '' ''` [18].
* **Cursor Positioning:** You can use terminal escape codes to move the cursor after the text is inserted. For example, using **`\C-B` (Control-B)** will move the cursor backward one space [18].
* **Example (Git Commit):** A binding for `git commit -m ""` that inserts the text and then uses `\C-B` to place the cursor **inside the quotation marks** so you can start typing the message immediately [18].