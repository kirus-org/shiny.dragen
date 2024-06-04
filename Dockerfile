# dockerfile at the upper level of DESCRIPTION file
## remove all docker image withoyt --tag
#docker image rmi $(docker images -f "dangling=true" -q)
#docker build --tag kmezhoud/shiny.dragen:vcf .
#docker run -d -v /media/DATA/fastq:/home/Proliant -p  3838:3838 kmezhoud/shiny.dragen:vcf
## mount partition in Dragen server
# docker run -d --restart unless-stopped -v /staging/Proliant/NextSeq/NSeq_Genetic/Test_App:/home/Proliant -p  3838:3838 kmezhoud/shiny.dragen:vcf
# docker login
#docker push kmezhoud/shiny.dragen:vcf

# Base image https://hub.docker.com/u/rocker/
#FROM rocker/r-base
FROM rocker/shiny

                                              ####################
                                            #install linux deps
                                            ####################

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    apt-utils \
    libssh2-1-dev \
    libcurl4-openssl-dev \
    libssl-dev #\
#    texlive-latex-base \
#    texlive-latex-extra \
#    texlive-latex-recommended \
#    texlive-fonts-recommended \
#    texlive-extra-utils


## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    

### Setting nonroot group
#RUN addgroup --gid 1001 nonroot && \
#    adduser --uid 1001 --gid 1001 --disabled-password --gecos "" nonroot && \
#    echo 'nonroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


                                            ####################
                                            # install R packages
                                            ####################

#RUN R -e "install.packages(c('shiny', 'shinyFiles', 'shinythemes', 'shinydashboard','DT', 'processx', 'markdown'), repos='https://cran.rstudio.com/')"

RUN R -e "install.packages('shinyFiles', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('shinythemes', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('DT', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('processx', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('markdown', repos='https://cran.rstudio.com/')"


                                    ########################
                                    # configure shiny server
                                    ########################
 
 ## prepare mount partition
#RUN mkdir /srv/shiny-server/Proliant
## set permission read and execute access for everyone and 
## also write access for the owner of the file. 755
#RUN chmod -R 755 /srv/shiny-server/Proliant
 
## by default shiny user exist
## Add group named shiny to have access to shiny-server
#RUN addgroup --system shiny \
#    && adduser --system --ingroup shiny shiny

##  add shiny user to the sudo group, 
#RUN usermod -a -G sudo shiny

RUN chown -R shiny:root /usr/local/lib/R/site-library

#Set the non-root user
USER shiny


                                ########### BUILD and INSTALL shiny.dragen #############
                                
                                
## Without devtools we need existing shiny.dragen.tar.gz package
COPY shiny.dragen_0.9.00_R_x86_64-pc-linux-gnu.tar.gz /home
WORKDIR /home

#RUN R -e "options(lib.loc = '/usr/local/lib/R/site-library');install.packages('shiny.dragen_0.9.00.tar.gz', repos = NULL, type='source')"
RUN R -e "install.packages('shiny.dragen_0.9.00_R_x86_64-pc-linux-gnu.tar.gz', repos = NULL, type='source')"


# expose port
EXPOSE 3838

                                ################# RUN the app ########################
                                
#CMD ["R", "-e", "library(shiny.dragen); shiny.dragen()"]
CMD ["R", "-e", "library(shiny.dragen); shiny::runApp('/usr/local/lib/R/site-library/shiny.dragen/shiny.dragen', host = '0.0.0.0', port = 3838)"]
