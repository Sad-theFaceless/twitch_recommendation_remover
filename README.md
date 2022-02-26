# twitch_recommendation_remover
Bash script to [remove recommended channels or categories on Twitch](https://www.twitch.tv/settings/recommendations), without being dependent on the suggestions in the Browse tab.

## Download
### GNU/Linux
```bash
wget https://raw.githubusercontent.com/Sad-theFaceless/twitch_recommendation_remover/main/twitch_recommendation_remover.sh && chmod +x twitch_recommendation_remover.sh
```
### Windows
- Right click on the .ps1 script file, and **Save link as...** (verify the extension is .ps1)
- Once the file is downloaded, right click on it then **Run with PowerShell**

The first time you launch the PowerShell script, it will download all the prerequisite files in a temporary directory.  
It will then open a new prompt window that allows you to run the actual Bash script. ([see How to use](#how-to-use))

## How to use
```bash
./twitch_recommendation_remover.sh TYPE "NAME" Authorization_TOKEN Client-Id_TOKEN
```
- **TYPE** is either "**channel**" or "**category**".
- **NAME** is the name of the channel or the category.
- **Authorization_TOKEN** and **Client-Id_TOKEN** are the tokens retrieved from your Twitch ([see last section](#retrieve-the-authorization-and-client-id-tokens-on-twitch)).

## Example
```bash
./twitch_recommendation_remover.sh category "Pools, Hot Tubs, and Beaches" a1b2c3d4e5f6g7h8i9j10k11l12m13 m13l12k11j10i9h8g7f6e5d4c3b2a1
```

## Retrieve the "Authorization" and "Client-Id" tokens on Twitch
- Open the Developer tools in your browser
- Click on the **Network** tab
- Reload the Twitch page
- Click on a request named **gql** to look at their Request Headers. (**you need to be logged in**)
#### Chrome
![image](https://user-images.githubusercontent.com/21340420/155695072-1985b99e-30ca-48da-a7ba-aa7c8cbbe749.png)  
![image](https://user-images.githubusercontent.com/21340420/155755848-c43f08f0-398c-49e3-bf32-231f276e5e5c.png)
#### Firefox
![image](https://user-images.githubusercontent.com/21340420/155697210-0285483d-ac23-412e-9424-fb1eb9e9dbd6.png)  
![image](https://user-images.githubusercontent.com/21340420/155755887-4a37ead7-3c48-4215-a5fd-25802eec4c6d.png)
