# docker-msre
This repo is created for the purpose of creating a docker conatiner which includes not only support for OpenMC w DAGMC/MOAB, embree, and double_down libraries, but also
a Juputter notebook server. The reason d'etre for this is to run a virtual version of The Molten Salt Reactor experiment (MSRE), which was performed physically in the 60s at Oak Ridge National Lab (ORNL).

#Getting started:
1. Install the docker engine on your system (for windows and MacOS: docker-desktop, for Linux: docker server)
  Instructions for how to do this may be found on the Docker website at: [Docker installation](https://docs.docker.com/engine/install/)
2. Run the msre docker container.
    - Linux:
        1. Open a terminal, navigate to a directory where you want to run.
        2. Download the msre-docker runscript, and run it:
        ```{bash tidy=false}
        wget https://raw.githubusercontent.com/ebknudsen/docker-msre/main/run_docker.sh
        chmod u+x run_docker.sh
        ./run_docker.sh
        ```
        The script contains a call to ```docker run``` with some options preset. Among other things it sets up a subdirectory called notebooks which is shared between the conatiner and the host so that you can keep data between runs.
        Feel free to inspect the runscript if you prefer to run your docker manually. If you'd prefer for instance to run commands in the docker from a shell
        you may do so by adding the option ```--entrypoint /bin/bash``` to the docker run command.
        3. If you used the run-script "as is" you should now be able to open a browser and point it to "https://127.0.0.1:8888" and be treated with a login page to Jupyter.
        Please enter "docker" in the password box, which should provide you with the base Jupter Lab screen.
        4. In the example_notebooks folder open the MSRE.ipynb file. You are now ready to run!
