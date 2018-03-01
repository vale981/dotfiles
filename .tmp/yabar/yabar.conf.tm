#$ sed -e 's/0x/0x/g'
bar-list = ["topbar"];
topbar:{
	font: "Monospace, FontAwesome Bold 9";
	block-list: ["ya_diskspace", "ya_ws", "ya_title", "ya_date", "ya_diskusage", "ya_volume", "ya_uptime", "ya_cpu", "ya_thermal", "ya_brightness", "ya_bw", "ya_mem", "ya_disk", "ya_bat", "ya_wifi"];
	position: "bottom";
	gap-horizontal: 10;
	gap-vertical: 10;
	#width: 1100;
	height: 20;
	//If you want transparency, use argb, not rgb
	background-color-rgb: 0x586e75;
	underline-size: 2;
	overline-size: 2;
	slack-size: 4;
	#border-size: 2;
	#monitor: "LVDS1 HDMI1"; # get names from `xrandr`

	# various examples for internal blocks:
	ya_ws: {
		exec: "YABAR_WORKSPACE";
    underline-color-rgb: 0xde935f;
		align: "left";
		fixed-size: 40;
		internal-option1: "         ";
	}
	ya_title: {
		exec: "YABAR_TITLE";
		align: "left";
		justify: "left";
		fixed-size: 300;
	}
	ya_date:{
		exec: "YABAR_DATE";
		align: "center";
		fixed-size: 170;
		interval: 2;
		background-color-rgb:0x279DBD;
		underline-color-rgb:0xC02942;
		internal-prefix: " ";
		internal-option1: "%a %d %b, %I:%M";
	}
	ya_uptime:{
		exec: "YABAR_UPTIME";
		align: "right";
		fixed-size: 70;
		interval: 1;
		background-color-rgb:0x96B49C;
		underline-color-rgb:0xF8CA00;
		internal-prefix: " ";
		#internal-spacing: true;
	}
	ya_mem:{
		exec: "YABAR_MEMORY";
		align: "right";
		fixed-size: 70;
		interval: 1;
		background-color-rgb:0x45ADA8;
		underline-color-rgb:0xFA6900;
		internal-prefix: " ";
		#internal-spacing: true;
	}
	ya_bw: {
		exec: "YABAR_BANDWIDTH";
		align: "right";
		fixed-size: 110;
		interval: 1;
		internal-prefix: " ";
		internal-option1: "enp3s0"; # "default" or network interface from `ifconfig` or `ip link`
		internal-option2: " "; # characters to be placed before up/down data
		#background-color-rgb:0x547980;
		background-color-rgb:0x3EC9A7;
		underline-color-rgb:0xD95B43;
		#internal-spacing: true;
	}
	ya_cpu: {
		exec: "YABAR_CPU";
		align: "right";
		fixed-size: 60;
		interval: 1;
		internal-prefix: " ";
		internal-suffix: "%";
		background-color-rgb:0x98D9B6;
		underline-color-rgb:0xE97F02;
		#internal-spacing: true;
	}
	# ya_bat: {
	# 	exec: "YABAR_BATTERY";
	# 	align: "right";
	# 	fixed-size: 70;
	# 	interval: 1;
	# 	internal-suffix: "%";
	# 	internal-option1: "BAT0";
	# 	internal-option2: "    ";
	# 	#internal-spacing: true;
	# }
	ya_disk: {
		exec: "YABAR_DISKIO";
		align: "right";
		fixed-size: 110;
		interval: 1;
		internal-prefix: " ";
		internal-option1: "sda"; # name from `lsblk` or `ls /sys/class/block/`
		internal-option2: " "; # characters to be placed before in/out data
		background-color-rgb:0x49708A;
		underline-color-rgb:0xECD078;
		#internal-spacing: true;
	}
	ya_diskspace: {
		exec: "YABAR_DISKSPACE";
		align: "left";
		fixed-size: 120;
		interval: 10;
		internal-prefix: " ";
		# examples for this option:
		# "/dev/sda1"           first partition of device sda
		# "/dev/sdb"            all mounted partitions of device sdb
		# "/dev/mapper/vgc-"    all mounted logical volumes of volume group vgc
		# "/dev"                all mounted partitions / logical volumes
		internal-option1: "/dev/sda";
		background-color-rgb:0x49708A;
		underline-color-rgb:0xECD078;
	}
	# ya_wifi: {
	# 	exec: "YABAR_WIFI";
	# 	internal-prefix: "  ";
	# 	internal-suffix: " ";
	# 	internal-option1: "wlan0";
	# 	variable-size: true;
	# 	background-color-rgb: 0x444444;
	# }
	title: {
		exec: "xtitle -s";
		align: "left";
		fixed-size: 350;
		type: "persist";
		foreground-color-rgb:0xeeeeee;
		underline-color-rgb:0x373b41;
		overline-color-rgb:0x373b41;
	}
	# song:{
	# 	exec: "YABAR_SONG";
	# 	fixed-size: 200;
	# 	type: "periodic";
	# 	internal-option1: "google-play-music-desktop-player";
	# }
	keyboard: {
		exec: "YABAR_KEYBOARD_LAYOUT";
		interval: 1;
	}
}

