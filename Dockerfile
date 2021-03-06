FROM centos:7
# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;
# Install Ansible
RUN yum -y install epel-release
RUN yum -y install git sudo rsyslog NetworkManager python-setuptools python-devel gcc libffi-devel openssl-devel ansible
RUN yum clean all
RUN printf "[defaults]\nroles_path = /WunderMachina/playbook/roles" > /etc/ansible/ansible.cfg
# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
