def call(String buildStatus = 'STARTED') {
  buildStatus = buildStatus ?: 'SUCCESS'
  
  def color

  if (buildStatus == 'SUCCESS') {
    color = '#47ec05'
    emoji = ':smile:'
  }
  else if (buildStatus == 'UNSTABLE') {
    color = '#d5ee0d'
    emoji = ':confused:'
  }
  else {
    color = '#ec2805'
    emoji = ':frowning:'
  }
  
  attachments = [
    [
        "color": color,
        "blocks": [
            [
                "type": "header",
                "text": [
                    "type": "plain_text",
                    "text": "Kubernetes Deployment - ${deploymentName} Pipeline ${env.emoji}",
                    "emoji": true
                ]
            ],
            [
                "type": "section",
                "fields": [
                    [
                        "type": "mrkdwn",
                        "text": "*Job Name:*\n${env.JOB_NAME}"
                    ],
                    [
                        "type": "mrkdwn",
                        "text": "*Build Number:*\n${env.BUILD_NUMBER}"
                    ]
                ],
                "accessory": [
                    "type": "image",
                    "image_url": "https://raw.githubusercontent.com/sidd-harth/numeric/main/images/jenkins-slack.png",
                    "alt_text": "Slack Icon"
                ]
            ],
            [
                "type": "section",
                "text": [
                    "type": "mrkdwn",
                    "text": "Failed Stage Name: * `${env.failedStage}`"
                ],
                "accessory": [
                    "type": "button",
                    "text": [
                        "type": "plain_text",
                        "text": "Jenkins Build URL",
                        "emoji": true
                    ],
                    "value": "click_me_123",
                    "url": "${env.BUILD_URL}",
                    "action_id": "button-action"
                ]
            ],
            [
                "type": "divider"
            ],
            [
                "type": "section",
                "fields": [
                    [
                        "type": "mrkdwn",
                        "text": "*Git Commit:*\n${GIT_COMMIT}"
                    ],
                    [
                        "type": "mrkdwn",
                        "text": "*GIT Previous Success Commit:*\n$GIT_PREVIOUS_SUCCESSFUL_COMMIT}"
                    ]
                ],
                "accessory": [
                    "type": "image",
                    "image_url": "https://raw.githubusercontent.com/sidd-harth/numeric/main/images/github-slack.png",
                    "alt_text": "GitHub Icon"
                ]
            ],
            [
                "type": "section",
                "text": [
                    "type": "mrkdwn",
                    "text": "*Git Branch: * `${GIT_BRANCH}`"
                ],
                "accessory": [
                    "type": "button",
                    "text": [
                        "type": "plain_text",
                        "text": "GitHub Repo URL",
                        "emoji": true
                    ],
                    "value": "click_me_123",
                    "url": "${env.GIT_URL}",
                    "action_id": "button-action"
                ]
            ]
        ]
    ]
]

slackSend(iconEmoji: emoji, attachments: attachments)
  
}
