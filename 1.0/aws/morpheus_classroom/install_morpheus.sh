#downloads and installs morpheus rpm

MORPH_VER="<%=customOptions.morph_ver%>"

cd /var/tmp

wget https://downloads.morpheusdata.com/files/morpheus-appliance-${MORPH_VER}.el7.x86_64.rpm

rpm -ivh morpheus-appliance-${MORPH_VER}.el7.x86_64.rpm