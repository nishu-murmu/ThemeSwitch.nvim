# ThemeSwitch
Light weight color scheme switcher for neovim.


## Demo
https://github.com/user-attachments/assets/c8ff7963-d2d3-4a30-bcaa-00d540426957

## Installation

##### [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    "nishu-murmu/ThemeSwitch.nvim"
}
```
### Usage

#### Basic Usage
```lua
require("ThemeSwitch")
```

#### Update mappings
```lua
require("ThemeSwitch").setup({
    keymap = --your mappings
})
```

### Default Mappings
Mappings are fully customizable.

| Mappings       | Action                                                    |
| -------------- | --------------------------------------------------------- |
| `<leader>c`    | Toggle ThemeSwitch window                                 |

### License
MIT
