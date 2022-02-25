FROM amazonlinux
ADD ./10KIA748.sh /usr/src/10KIA748.sh
RUN chmod +x /usr/src/10KIA748.sh
CMD ["/usr/src/10KIA748.sh"]
