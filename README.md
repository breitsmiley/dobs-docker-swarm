# 1 Preparing Digital Ocean Droplets

## 1.1 Manager
1. Create Droplet
2. ssh root@**DROPLET_IP**

### 1.1.1 Install docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```
```bash
sh get-docker.sh
```

### 1.1.2 Init swarm
```bash
docker swarm init --advertise-addr DROPLET_IP
```

### 1.1.3 Create DO Volume and mount to droplet

Manually mount, format etc.
https://www.digitalocean.com/docs/volumes/how-to/format-and-mount/

```bash
sudo parted /dev/disk/by-id/scsi-0DO_Volume_volume-sfo2-01 mklabel gpt
sudo parted -a opt /dev/disk/by-id/scsi-0DO_Volume_volume-sfo2-01 mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/disk/by-id/scsi-0DO_Volume_volume-sfo2-01-part1
sudo mkdir -p /mnt/dobs-volume
echo '/dev/disk/by-id/scsi-0DO_Volume_volume-sfo2-01-part1 /mnt/dobs-volume ext4 defaults,nofail,discard 0 2' | sudo tee -a /etc/fstab
sudo mount -a

```



## 1.2 Worker
1. Create Droplet
2. ssh root@**DROPLET_IP**

### 1.2.1 Install docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```
```bash
sh get-docker.sh
```

### 1.2.2 Add droplet to the swarm

**Run next command on the manager for seeing command for join worker to the swarm:** 

```bash
docker swarm join-token worker
```

**This is command from previous output!!!**
```bash
docker swarm join --token JOIN_TOKEN MANAGER_IP:2377
```


### 1.1.3 Mount Volume to droplet ( Option 2)
Attach volume via UI to droplet

Manually mount
https://www.digitalocean.com/docs/volumes/how-to/format-and-mount/

```bash
sudo mkdir -p /mnt/dobs-volume
echo '/dev/disk/by-id/scsi-0DO_Volume_volume-sfo2-01-part1 /mnt/dobs-volume ext4 defaults,nofail,discard 0 2' | sudo tee -a /etc/fstab
sudo mount -a
```


# 2 Running project

## 2.1 Clone project repository on the manager
```bash
mkdir -p ~/swarm
cd ~/swarm
git clone https://github.com/breitsmiley/dobs-docker-swarm.git
```

## 2.2 Start swarm

```bash
./sh/init-swarm-secrets.sh
```

```bash
docker stack deploy --compose-file docker-stack.yml stackdemo
```

