#!groovy
import java.io.File;
import java.io.IOException;

notifyEmailId = "vramisetti@west.com"
devEmailId =    "vramisetti@west.com"
qaEmailId =     "vramisetti@west.com"
prodEmailId = "vramisetti@west.com"
waitingTime = 24
branchName = env.BRANCH_NAME

// isMaster = branchName == "master" || branchName == "dev"

if ( branchName == 'dev-test') {

 node {
    //Java path setup
    env.JAVA_HOME="${tool 'jdk-1.8'}"
    env.PATH="${JAVA_HOME}/bin:${PATH}"
    env.PATH = "${tool 'maven-default'}/bin:${env.PATH}"
    // defining artifactory configurations
    def server = Artifactory.server('artifacts')

try {

  stage 'Clone Code'

          deleteDir()
          checkout scm
          repositoryURL = sh(script: 'git config remote.origin.url', returnStdout: true).trim()
          echo "${repositoryURL}"
          repositoryName = sh (script: "echo ${repositoryURL} | rev | cut -d '.' -f2 | cut -d '/' -f1 | rev ", returnStdout: true).trim()
          echo "${repositoryName}"

//    stage 'Build'
//
//           sh "mvn compile"
//
//    stage 'Test'
//
//           sh "mvn test"
//
//    stage 'package'
//
//           sh "mvn package"
//
//
// //Uploading artifacts to Jfrog artifactory
//    stage 'Upload artifacts to Dev'
//
//         def uploadSpec = """{
//         "files": [
//          {
//            "pattern": "${WORKSPACE}/target/*.jar",
//             "target": "Customer-Experience-maven-dev/${repositoryName}/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
//          },
//
//          {
//
//            "pattern": "${WORKSPACE}/shell/*.sh",
//             "target": "Customer-Experience-maven-dev/${repositoryName}/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
//
//           }
//
//            ]
//
//            }"""
//
//           def buildInfo1 = server.upload(uploadSpec)
//           server.publishBuildInfo(buildInfo1)
//
//
//
//   stage 'Tower template execution-DEV'
//
//       towerdeploy("Skynet-App", "Skynet-App", "Dev", "dev")
//
//
//   stage 'QA deployment'
//
//          notifyQAtodeploy()
//
//                 try{
//                   proceedConfirmation("proceed1","Deploy files into QA server ?")
//                   } catch(e) {
//
//                   notifyBuild('ABORTED')
//                   throw e;
//                   }
//
//
//
//     //Uploading artifacts to Jfrog artifactory
//      stage 'Upload artifacts to QA'
//
//               uploadSpec = """{
//               "files": [
//                {
//                 "pattern": "${WORKSPACE}/target/*.jar",
//                 "target": "Customer-Experience-maven-qa/${repositoryName}/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
//                },
//
//                {
//                 "pattern": "${WORKSPACE}/shell/*.sh",
//                 "target": "Customer-Experience-maven-qa/${repositoryName}/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
//                 }
//                ]
//
//                }"""
//
//
//           buildInfo1 = server.upload(uploadSpec)
//           server.publishBuildInfo(buildInfo1)
//
//
//
//     stage 'Tower template execution-QA'
//
//           towerdeploy("Skynet-App","Skynet-App", "QA", "qa")


      /*

      stage 'Prod deployment'

             notifyPRODtodeploy()

                    try{
                      proceedConfirmation("proceed1","Deploy files into Prod server ?")
                      } catch(e) {

                      notifyBuild('ABORTED')
                      throw e;
                      }

      //Uploading artifacts to Jfrog artifactory
       stage 'Upload artifacts to prod'

                uploadSpec = """{
                "files": [
                 {
                  "pattern": "${WORKSPACE}/target/*.jar",
                  "target": "Customer-Experience-maven-prod/${repositoryName}/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
                 },

                 {
                  "pattern": "${WORKSPACE}/shell/*.sh",
                  "target": "Customer-Experience-maven-prod/${repositoryName}/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
                  }
                 ]

                 }"""

          buildInfo1 = server.upload(uploadSpec)
          server.publishBuildInfo(buildInfo1)



      stage 'Tower template execution-QA'

            towerdeploy("Skynet-App","Skynet-App", "PROD", "prod")



            def notifyPRODtodeploy (String buildStatus = 'STARTED') {
             // build status of null means successful
             buildStatus =  buildStatus ?: 'SUCCESSFUL'
             def toList = prodEmailId
             def subject = "PROD: '${repositoryName}' artifact ready for Deploy to PROD servers"
             def summary = "${subject} (${env.BUILD_URL})"
             def details = """
               <p>Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' is ready for Deploy to PROD servers.</p>
               <p>Click here Approve. "<a href="${env.BUILD_URL}/input">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>

                  """
           emailext body: details,mimeType: 'text/html', subject: subject, to: toList

           }



                 */


     }

      catch(e) {
      notifyBuild('FAILED')
      throw e;

      }

}

} else {
echo "Aborted: not a Master branch"
}


      def towerdeploy(String jobTemplateName, String inventoryName, String groupName, String repoName)  {
      buildversion = sh(
      script: "mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version|grep -Ev '(^\\[|Download|Downloading|Downloaded\\w+:)'",
      returnStdout: true
      )
      sh "echo ${buildversion}"
      extraVars = "{'VERSION': '${buildversion}', 'BuildNumber': '${env.BUILD_NUMBER}', 'REPO': '${repoName}' , 'BRANCHNAME': '${env.BRANCH_NAME}'}"
      ansibleTower(
      towerServer: 'tower',
      templateType: 'job',
      jobTemplate: "${jobTemplateName}",
      importTowerLogs: true,
      inventory: "${inventoryName}",
      limit: "${groupName}",
      removeColor: false,
      verbose: true,
      credential: '',
      extraVars:"${extraVars}"

          )

      }

//Email notification when build failed
def notifyBuild(String buildStatus = 'FAILED') {
def toList = notifyEmailId
def subject = "${buildStatus}: Job name: '${env.JOB_NAME}' Build Number: '[${env.BUILD_NUMBER}]'"
def summary = "${subject} (${env.BUILD_URL})"
def details = """
    <p>Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Build Status is failed.To Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>

                """
    emailext body: details,mimeType: 'text/html', subject: subject, to: toList
    }


     def notifyQAtodeploy (String buildStatus = 'STARTED') {
      // build status of null means successful
      buildStatus =  buildStatus ?: 'SUCCESSFUL'
      def toList = qaEmailId
      def subject = "QA: '${repositoryName}' artifact ready for Deploy to QA servers"
      def summary = "${subject} (${env.BUILD_URL})"
      def details = """
        <p>Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' is ready for Deploy to QA servers.</p>
        <p>Click here Approve. "<a href="${env.BUILD_URL}/input">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>

           """
    emailext body: details,mimeType: 'text/html', subject: subject, to: toList

    }


    def proceedConfirmation(String id, String message) {
    def userInput = true
    def didTimeout = false

    try {
    timeout(time: waitingTime, unit: 'HOURS') { //
    userInput = input(
    id: "${id}", message: "${message}", parameters: [
    [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Confirm to proceed !']
          ])
        }

      }

       catch(e) { // timeout reached or input false
       def user = e.getCauses()[0].getUser()
       if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
       didTimeout = true
       if (didTimeout) {
            echo "no input was received abefore timeout"
            currentBuild.result = "FAILURE"
            throw e
        } else if (userInput == true) {
           echo "this was successful"

            } else {
              userInput = false
              echo "this was not successful"
              currentBuild.result = "FAILURE"
              println("catch exeption. currentBuild.result: ${currentBuild.result}")
              throw e
              }

          }  	else {
              userInput = false
              echo "Aborted by: [${user}]"
              }

          }

      }


                 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                // {
                //
                //   "pattern": "${WORKSPACE}/documentation/preprodconfigs/led01506/*.yml",
                //
                //   "target": "libs-snapshot-local/Customer-Experience/${repositoryName}/Dev/${env.BUILD_NUMBER}/led01506/"
                //
                //  },
                //
                //  {
                //
                //    "pattern": "${WORKSPACE}/documentation/preprodconfigs/led01506/*.xml",
                //
                //     "target": "libs-snapshot-local/Customer-Experience/${repositoryName}/Dev/${env.BUILD_NUMBER}/led01506/"
                //
                //   },
                //
                //   {
                //
                //    "pattern": "${WORKSPACE}/documentation/preprodconfigs/led01506/*.conf",
                //
                //    "target": "libs-snapshot-local/Customer-Experience/${repositoryName}/Dev/${env.BUILD_NUMBER}/led01506/"
                //
                //    }
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
