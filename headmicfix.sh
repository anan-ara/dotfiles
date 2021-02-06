#!/bin/bash
index=$(pacmd list-sources | egrep 'index|ports|analog-input-headset-mic' | egrep '\*\sindex:\s+[0-9]'  | cut -d':' -f2);

acpi_listen | while IFS= read -r line;
do
	if [ "$line" = "jack/headphone HEADPHONE plug" ]
	then
		pacmd set-source-port $index analog-input-headset-mic;
		pactl set-source-volume 1 40%;
	elif [ "$line" = "jack/headphone HEADPHONE unplug" ]
	then
		pacmd set-source-port $index analog-input-internal-mic;
		pactl set-source-mute 1 true;
	fi
done
