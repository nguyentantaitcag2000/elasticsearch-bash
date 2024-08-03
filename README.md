# for Window
    - Add path of project to Environment Variables
# for Mac
    - For example: the source code in ~/bash
    - Open ~/.zshrc and add 
    ```
    bash="~/bash"
    export PATH="$bash:$PATH" 
    ln -sf "$bash/helper.sh" helper
    ```
    Apply the changes
    ```
    source ~/.zshrc
    ```
# for Linux
    - For example: the source code in ~/bash
    - Open ~/.bashrc and add 
    ```
    bash="~/bash"
    export PATH="$bash:$PATH" 
    ln -sf "$bash/helper.sh" helper
    ```
    Apply the changes
    ```
    source ~/.bashrc
    ```