package com.blackducksoftware.integration.hub.packman.packagemanager

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component

import com.blackducksoftware.integration.hub.bdio.simple.model.DependencyNode
import com.blackducksoftware.integration.hub.packman.PackageManagerType
import com.blackducksoftware.integration.hub.packman.packagemanager.maven.MavenPackager
import com.blackducksoftware.integration.hub.packman.util.InputStreamConverter

@Component
class MavenPackageManager extends PackageManager {
    public static final String POM_FILENAME = 'pom.xml'

    @Autowired
    InputStreamConverter inputStreamConverter;

    @Value('${packman.bom.aggregate}')
    boolean aggregateBom

    PackageManagerType getPackageManagerType() {
        return PackageManagerType.MAVEN
    }

    boolean isPackageManagerApplicable(String sourcePath) {
        File sourceDirectory = new File(sourcePath)
        if (sourcePath && sourceDirectory.isDirectory()) {
            File pomFile = new File(sourceDirectory, POM_FILENAME)
            return pomFile.isFile()
        }

        false
    }

    List<DependencyNode> extractDependencyNodes(String sourcePath) {
        def mavenPackager = new MavenPackager(inputStreamConverter, sourcePath, aggregateBom)
        def projects = mavenPackager.makeDependencyNodes()
        return projects
    }
}