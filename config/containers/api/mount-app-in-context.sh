# Because docker doens't let you include resources outside of your docker directory
# And because I want to keep my app dockerfile and db dockerfile together, I have this
# glorious hack to mount the app in a subdirectory of itself. beware.
mount -o bind ../../.. src/app 
