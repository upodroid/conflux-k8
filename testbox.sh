 kubectl run --namespace default testbox --rm --tty -i --restart='Never' \
   --image ubuntu -- bash

# apt install iputils-ping net-tools -y