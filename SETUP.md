# Server Setup


## Windows

### Dedicated Server

#### Requirements:
* [SteamCMD](https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip) - an official Valve tool for installing dedicated servers.

#### Setup:
1. Download SteamCMD from the above and extract it to a folder of your choice.
2. Open SteamCMD and run this command to set where your server will be downloaded to.
    ```
    force_install_dir <directory>
    ```
    Then run this to login to steam, this is required to download the dedicated servers.
    ```
    login anonymous
    ```

3. **OPTIONAL**, but recommended : Install CS:S and TF2 content. Alternatively you can mount it directly from another install location on your PC, which will be explained in step 5.

    To install these to the server, run the following commands:
    ```
    app_update 232330 // css
    app_update 232250 // tf2
    ```

4. Install the GMod server itself.

    ```
    app_update 4020 validate
    ```

    Once completed, you should find the server downloaded into the directory entered in the first command in step 2.

5. To mount the games mentioned before to the server:

    Add these lines to `garrysmod/cfg/mount.cfg`, with the directories replaced with your install locations.
    ```
    "cstrike"	"D:\gmt-server\cstrike"
	"tf"		"D:\gmt-server\tf"
    ```

6. Clone this repository as an addon into `garrysmod/addons/`.

    You can clone with [GitHub Desktop](https://desktop.github.com/), or through terminal with the command below.

    ```
    git clone https://github.com/cattslmao/tcf.git
    ```

    The path should look like after cloning `garrysmod/addons/tcf/gamemodes/gmodtower/`.

7. Clone the addon dependencies listed in the readme into `garrysmod/addons/`.

8. Install the required binary module dependencies listed in the readme into `garrysmod/lua/bin/`.

9. Copy `template.env` from the tcf repo, and paste it into the server's `garrysmod` folder with the name of just `.env`. Edit this file to use your SQL credentials.

    **If you haven't setup SQL yet, please read the guide below this before running your server.**

10. Setup the server BAT file.

    Create a BAT file named whatever you like in the same folder as `srcds.exe`, this file will launch the lobby server and can be copied and changed for the other gamemodes.

    Enter the script below into the file.

    ```
    srcds.exe +maxplayers 64 -console +gamemode gmtlobby +map gmt_build0s3b -nomaster
    ```

11. Open the BAT file and run the server!

### SQL Database

#### Requirements:
* [MariaDB](https://mariadb.org/download/) - The database itself.
* [HeidiSQL](https://www.heidisql.com/download.php) - An easy editor for the database. This however is included in the MariaDB install so you can skip this for now.

#### Setup:
1. Install MariaDB from the link above, don't allow remote connections, and install it as a service. The default settings should be fine.

2. After installing, it's recommended to disable the service from running on startup. You can do this by opening Windows services by searching for `Servicies` in the windows search, finding MariaDB in the list, right-clicking and going into `Properities`, and changing `Startup Type` to `Disabled`.

    You can go back here to start or stop it whenever needed.

3. Open HeidiSQL and click `New` on the bottom left of the window.

    Change `Network type` at the top to `MariaDB or MySQL (TCP/IP)`.
    
    Enter the credentials as recommended below:
    ```
    Hostname: localhost
    User: root
    Password: < the password you entered during the MariaDB install, or none >
    Port: < the port you entered during the MariaDB install, or 3306 >
    ```

    Click open on the right side of the window, and it should log you in and let you view the SQL.

4. When logged into the SQL, right-click on the session at the top, called `Local` by default, and goto `Create new -> Database`. This will be where your GMT data lives. Name it whatever you like.

5. Once the database is created, click on it, then goto `File` on Heidi's top menubar, and click `Run SQL file`. Browse to the cloned TCF repo and use `gmt.sql`.

6. Once done importing, you should be good to go!
    

## Linux
todo