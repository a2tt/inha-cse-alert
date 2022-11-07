# inha-cse-notice

인하대학교 공지사항과 컴퓨터공학과 게시판을 주기적으로 크롤링하여, 새로운 글이 올라왔을 때 텔레그램으로 알림을 보냅니다.

## Prerequisites

- Download [Terraform](https://www.terraform.io/downloads)
- [Create AWS Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html).
Typically, but not as a best practice, you can simply add an AdministratorAccess policy to run Terraform.

## Configuration

`$ cp application/configs_example.yml application/configs.yml`

Fill in the following variables:

1. `TELEGRAM_TOKEN` : 텔레그램 봇 토큰
    > [Create a new Telegram bot with BotFather](https://learn.microsoft.com/en-us/azure/bot-service/bot-service-channel-connect-telegram?view=azure-bot-service-4.0#create-a-new-telegram-bot-with-botfather) 를 따라하시면 봇을 생성할 수 있습니다.
2. `TELEGRAM_TARGET_ID` : 유저(or 그룹) ID
    > 자신의 ID 는 https://t.me/getmyid_bot 에서 확인할 수 있습니다.
3. `S3_BUCKET_NAME` : 게시글 정보를 저장 할 AWS S3 버킷 이름

## Usage

Set environment variable first:

```bash
export ENVIRONMENT=dev
```

- `$ make init`  
    : 이 프로젝트를 처음으로 설정하는 경우, Terraform workspace, backend 를 구성합니다.
    > When initialize this project at first, it initialize terraform workspace and backend.
- `$ make package`  
    : AWS Lambda 실행에 필요한 함수와 계층 Zip 파일을 생성합니다.
    > Create Zip file for AWS Lambda function and its layer.
- `$ make apply`  
    : Terraform 을 이용하여, 이 프로젝트에서 필요로 하는 AWS 리소스들을 생성합니다.
    > Create and launch AWS resources that are need for this project by using Terraform.
- `$ make deploy`  
    : 위에서 언급한 `package`, `apply` 명령을 통하여 프로젝트를 배포합니다. 주로 코드가 변경 되었을 경우에 사용합니다.
    > Run `package` and `apply` command above to deploy project, especially when it is changed.
- `$ make destroy`
    : 이 프로젝트에서 생성한 AWS 리소스들을 삭제합니다.
    > Terminate and delete all resources created by this project. 
- `$ make cleanup`  
    : AWS Lambda 와 관련된 Zip 파일들을 삭제합니다.
    > Remove AWS Lambda related zip files from local storage.
