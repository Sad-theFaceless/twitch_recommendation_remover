# twitch_recommendation_remover
Bash script to [remove recommended channels or categories on Twitch](https://www.twitch.tv/settings/recommendations), without being dependent of Twitch's own suggestions in the homepage.

**DOES NOT WORK ANYMORE** as Twitch now verifies request integrities.

## Download
### GNU/Linux
```bash
wget https://raw.githubusercontent.com/Sad-theFaceless/twitch_recommendation_remover/main/twitch_recommendation_remover.sh && chmod +x twitch_recommendation_remover.sh
```
### Windows
- Right click on [this link](https://github.com/Sad-theFaceless/twitch_recommendation_remover/raw/main/twitch_recommendation_remover.ps1), and **Save link as...**
- Once the file is downloaded, right click on it then **Run with PowerShell**

*The first time you launch the PowerShell script, it will download all the prerequisite files in a temporary directory.  
It will then open a new prompt window that allows you to run the actual Bash script. ([see Usage](#usage))*

## Usage
```bash
./twitch_recommendation_remover.sh TYPE "NAME" Authorization_TOKEN
```
- **TYPE** is either **channel** or **category**.
- **NAME** is the name of the channel or the category (put it between double quotes).
- **Authorization_TOKEN** is the token retrieved from your Twitch ([see last section](#retrieve-the-authorization-token-on-twitch)).

## Example
```bash
./twitch_recommendation_remover.sh category "Pools, Hot Tubs, and Beaches" a1b2c3d4e5f6g7h8i9j10k11l12m13
```

## Retrieve the "Authorization" token on Twitch
- Open Twitch in your browser (**sign in if you are not**)
- Open the Developer tools (F12 by default)
- Click on the **Network** tab
- Reload the Twitch page
- Click on a request named **gql** to look at their Request Headers

*This token is given to you when you log in to Twitch. It is used by the script to get an access to your account, in order to remove the recommendations from it.*

#### Chrome
![image](https://user-images.githubusercontent.com/21340420/155695072-1985b99e-30ca-48da-a7ba-aa7c8cbbe749.png)  
![image](https://user-images.githubusercontent.com/21340420/156946839-932584f6-6fd2-4cf1-8ea1-b5dc250bd0ad.png)
#### Firefox
![image](https://user-images.githubusercontent.com/21340420/155697210-0285483d-ac23-412e-9424-fb1eb9e9dbd6.png)  
![image](https://user-images.githubusercontent.com/21340420/156946930-99f8b5b9-1cdc-4c55-9a19-d59709cb54b6.png)

