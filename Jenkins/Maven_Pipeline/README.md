## Maven:

Lifecycle (default & clean & site)

Each lifecycle has its own different phases

Phases comprises of	Goals

Goals are --> Maven Plugin = group of goals. Goals comprises of Tasks (specific)
			

    Validate :- Validate the project is correct and all necessary information is available or not .
    
    Compile :- Create source code of the project.
    
    Test(optional) :- Test the compiled smpile yourource code using a suitable unit testing framework. These tests should not require the code be packaged or deployed.
    
    Package :- Take the compiled code and package it as a jar or war as per pom file and move into  target folder.
    
    verify – Run any checks on results of integration tests to ensure quality criteria are met.
    
    install – Install the package into the local repository, for use as a dependency in other projects locally.
    
    deploy – Done in the build environment, copies the final package to the remote repository for sharing with other developers and projects.
