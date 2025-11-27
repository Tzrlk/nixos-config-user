# Delegate to files included in a config dir.
for file in ~/.bashrc.d/*.sh; do
	. ${file}
done
unset file
