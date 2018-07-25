#!groovy
notifyEmailId = "vramisetti@west.com"

pipeline {
  agent any
stages{
  stage ('Appprove Trigger template'){
    steps{
      script{
        notifyDev()
        proceedConfirmation("proceed1","Approve to Trigger")
        ansibleTower(
            towerServer: 'tower',
            templateType: 'job',
            jobTemplate: 'Skynet-App',
            importTowerLogs: true,
            inventory: 'Skynet-App',
            jobTags: '',
            limit: '',
            removeColor: false,
            verbose: true
            )
          }
        }
      }
    }
  post {
        success {
          mail to: notifyEmailId,
          subject: "Succeeded Pipeline: ${currentBuild.fullDisplayName}",
          body: "Build got success check status @ ${env.BUILD_URL}"
      }
      failure {
        mail to: notifyEmailId,
        subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
        body: "Something is wrong with ${env.BUILD_URL}"
      }
    }
  }


def notifyDev(String buildStatus = 'STARTED') {
// build status of null means successful
buildStatus =  buildStatus ?: 'SUCCESSFUL'
def toList = notifyEmailId
def subject = "Dev: Template is ready for to Trigger"
//def summary = "${subject} (${env.BUILD_URL})"
def details = """
<p>Click here to Promote  and Template will trigger. "<a href="${env.BUILD_URL}/input">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>
"""
emailext body: details,mimeType: 'text/html', subject: subject, to: toList
}
def proceedConfirmation(String id, String message) {
  def userInput = true
  def didTimeout = false
  try {
      userInput = input(
        id: "${id}", message: "${message}", parameters: [
        [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Confirm to proceed !']
        ])
      } catch(e) { // timeout reached or input false
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
                  println("catch exeption. currentBuild.result: Common_prove")
                  throw e
                }
                } else {
                  userInput = false
                  echo "Aborted by: [${user}]"
                }
              }
            }
