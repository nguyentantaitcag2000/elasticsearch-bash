for Window
    - Add folder containing helper.bat to Environment Variables
for Linux
    - Create a symbolic link for the folder containing helper
for Mac
    - Open ~/.zshrc and add 
    ```
    bash="/Users/tainguyen/bash"
    export PATH="$bash:$PATH" 
    ln -sf "$bash/helper.sh" helper
    ```
    Apply the changes
    ```
    source ~/.zshrc
    ```