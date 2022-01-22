## maven with Docker: (three ways)

1. create a maven project and build a docker image separatley which can be shared which has (pom.exl and run mvn pacakge command.. using openjdk as base image also can setup the voume to your local repository refer bookmark

2. create image directly from the maven project by having a plugin in pom.xml (using spotify plugin) and run that image separateley

3. create and run the container without docker daemon directly from the maven project using a plugin in pom.xml (google jib plugin)