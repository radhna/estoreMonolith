## Reference Implementation 2.1 - Monolith Migration from OnPrem to OpenShift.....

**Clone the original Repo**

 - Git Clone the Original Source Code of eStoreMonolith
 
**Create a new Repo**

- Create an empty repository in the Developer’s org of GitHub

- Change the remote origin

- Add git remote for the cloned project

- Push the Original source code to the cloned repo


**Update Github Configuration with Webhook**

Goto Settings —> Hooks —> Add webhook —> PayLoad URL : 
Take Jenkins host url of the cluster and add generic-webhook-trigger/invoke?token=XXXXXXX 
Content type : application/json 
Secret : empty SSL verification : Disable 
Check Just the push event.

Once webhook is Added, a build gets triggered in jenkins under the free style project created.

**Update the env.json file**

Update is required only for the component_name and the project/namespace where it needs to be deployed

