# twitch_recommendation_remover
Bash script to remove recommended channels or categories on Twitch, without being dependent on the suggestions in the Browse tab.

## Download
### GNU/Linux
```bash
wget https://raw.githubusercontent.com/Sad-theFaceless/twitch_recommendation_remover/main/twitch_recommendation_remover.sh && chmod +x twitch_recommendation_remover.sh
```

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
- Reload the Twitch page
- Look at the Network requests
- Search for the requests named **gql** to look at their Request Headers. (**you need to be logged in**)
#### Chrome
![image](https://user-images.githubusercontent.com/21340420/155695072-1985b99e-30ca-48da-a7ba-aa7c8cbbe749.png)  
![image](https://user-images.githubusercontent.com/21340420/155696310-d8f1c535-57eb-4b5b-915a-7e5cf70c2087.png)
#### Firefox
![image](https://user-images.githubusercontent.com/21340420/155697210-0285483d-ac23-412e-9424-fb1eb9e9dbd6.png)  
![image](https://user-images.githubusercontent.com/21340420/155697937-7b4b8e88-5393-43fa-bf78-8b54b921405a.png)
