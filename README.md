# Yet another Pi-hole list

> Actually this project is not 'yet another'. I tried to improve what other projects missed. Also added an auto updater.

 [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![Twitter Follow](https://img.shields.io/twitter/follow/javanrasokat.svg?style=social&label=Follow)](https://twitter.com/intent/follow?screen_name=javanrasokat)

**Supports the new Pi-hole 5 and above.**

## Quickstart
```
cd ~
git clone --depth=1 https://github.com/JavanXD/ya-pihole-list.git ya-pihole-list
cd ya-pihole-list
sudo chmod a+x adlists-updater.sh
sudo sh adlists-updater.sh
```


## How to append your own adlists

1. Fork this project.
2. Add your own blocklist to the ``adlists.list.updater`` file.
3. Change the ``adListSource`` variable in the `adlists-updater.sh` file to your custom blocklist collection.


## Enabling Raspbian and Pi-hole Auto Updater

Add the argument `1` to your `sudo sh adlists-updater.sh 1` call. 

## Updating your adlists automatically

> Unfortunately the Pi-hole Gravity script does not automatically update the adlists. Therefore this Updater was developed to do this job. However, it is very important to always use up-to-date blocklists to block the latest phishing sites. In addition, this project takes care to use only blocklists that are updated regularly.


1. Create a scheduled task to run the script:

	```
	sudo crontab -e
	```

2. Add this line to make it runs every 12 hour, but you can change it to whatever you like:

	```
	0 */12 * * * sudo /home/pi/ya-pihole-list/adlists-updater.sh 1 >/dev/null
	```

## Screenshots
<img width="900" alt="grafik" src="https://user-images.githubusercontent.com/4342160/115691780-a5de6180-a35e-11eb-99d9-256b86d7b921.png">

<img width="900" alt="grafik" src="https://user-images.githubusercontent.com/4342160/115691582-7d566780-a35e-11eb-93e2-59c9c5fcbd65.png">


## Other

### Helpful links
* https://filterlists.com/ - A great search engine to find suitable blocklists.
* https://firebog.net/ - A collection of good blocklists.

### License
Each converted / modified list file is licensed under the same license as the original list.
### Disclaimer
This project is in no way affiliated with the core Pi-Hole project or organization. This project was created as a contribution to the community. Use at your own risk.
