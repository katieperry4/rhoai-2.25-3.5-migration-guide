## 

## **2.9. Kubeflow Training Operator \- Before upgrade** {#2.9.-kubeflow-training-operator---before-upgrade}

You can upgrade Red Hat OpenShift AI 2.25.9 (and later) to 3.5 while PyTorchJobs are running; the jobs continue to run during the upgrade process and complete as normal.

Before you upgrade to OpenShift AI 3.5, get a list of PyTorchJob resources on your OpenShift cluster. You can then use this list to compare against PyTorchJob resources on your OpenShift cluster after you upgrade to 3.5.

**Note**

The Kubeflow Training Operator (KFTO) v1 is deprecated starting with theOpenShift AI 2.25.9 (and later) and is planned to be removed in a future release. This deprecation is part of the OpenShift AI transition to Kubeflow Trainer v2, which delivers enhanced capabilities and improved functionality.

**Prerequisites**

* You have cluster administrator access to your cluster.

* You have logged in to your OpenShift cluster.

**Procedure**

* Run the following command to get a list of PyTorchJob resources on your OpenShift cluster:  
  ```bash
  $ oc get pytorchjobs -A
  ```

**Verification**

The command returns a list of PyTorchJob resources, as shown in this example output:  
NAMESPACE          NAME                           STATE       AGE  
pytorch-training   pytorch-distributed-training   Running     4m27s

**Warning**

As a cluster administrator, if you want to perform an OpenShift Container Platform (OCP) upgrade, an OCP upgrade process might stop nodes which might interrupt PyTorchJobs. Ensure that either no PyTorchJobs are running during the OCP upgrade or verify that the running PyTorchJobs include checkpointing so that they are resilient to failure.

## **2.10. OpenShift AI Operator \- Before upgrade** {#2.10.-openshift-ai-operator---before-upgrade}

Before upgrading Red Hat OpenShift AI from version 2.25.9 (and later) to 3.5, complete the following steps to ensure a successful migration of the OpenShift AI Operator.

**Note**

If you have bookmarked dashboard URLs, you must recreate redirects **after** the upgrade is complete. For more information, see the [Resolving dashboard URL 404 errors after upgrading from 2.x to 3.x](https://access.redhat.com/solutions/7137771).

**Prerequisites**

* You have upgraded to OpenShift 4.19.9 or later according to OpenShift documentation on [Updating clusters](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html/updating_clusters/index).

* You have set the **Update approval** for the Red Hat OpenShift AI 2.25.9 (and later) subscription to **Manual**. This prevents unintended automatic upgrades and requires you to explicitly confirm the upgrade.

* Kueue is set to **Removed** or **Unmanaged** (with external Red Hat build of Kueue Operator installed).

* You have completed the Migrate **InferenceServices** to **RawDeployment** mode steps to convert all serving deployments to **RawDeployment** mode and removed the OpenShift Service Mesh 2 Operator.

* You have configured Model Serving to ignore hardware profile annotations to avoid inference service restarts during the upgrade, according to Update the inferenceservice-config ConfigMap.

* You migrated any other component workloads that require migration before the upgrade.

* You have OpenShift cluster administrator permissions to install Operators and edit **DataScienceCluster** and **DataScienceClusterInitialization** resources.

**Procedure**

1. Verify that the **Update approval** for the Red Hat OpenShift AI 2.25.9 (and later) subscription is set to **Manual**.

   If the **Update approval** is not set to **Manual**, you must set it now. This prevents automatic upgrade when you change the subscription channel.

2. Edit the **Update channel** for Red Hat OpenShift AI to **stable-3.x** or **stable-3.5**, depending on your preference.

   For information about subscription channels and their lifecycle, see [Red Hat OpenShift AI Self-Managed Life Cycle](https://access.redhat.com/support/policy/updates/rhoai-sm/lifecycle#stable).

**Verification**

1. Verify that the Red Hat OpenShift AI 2.25.9 (and later) CSV status shows **Succeeded**.  
   ```bash
   $ oc get csv -n redhat-ods-operator
   ```

   **Note**  
   If you are using a custom operator namespace, replace **redhat-ods-operator** with your specific namespace names.

2. Verify that the **DataScienceCluster** (DSC) and **DSCInitialization** (DSCI) custom resources show a status of **Ready**.

   ```bash
   $ oc get dsc -o custom-columns='NAME:.metadata.name,STATUS:.status.phase'
   $ oc get dsci -o custom-columns='NAME:.metadata.name,STATUS:.status.phase'
   ```

   **Important**  
   The reconciliation might take time to complete. Do not proceed with the upgrade if the **DSC** and **DSCI** custom resources show errors in the **Status** sections.

3. Verify that all operator pods in the operator namespace have a status of **Running** and their **Ready** condition is **True**.

   ```bash
   $ oc get pods -n redhat-ods-operator -o custom-columns='NAME:.metadata.name,READY:.status.conditions[?(@.type=="Ready")].status,STATUS:.status.phase'
   ```

   **Note**  
   If you are using a custom operator namespace, replace **redhat-ods-operator** with your specific namespace names.

4. Verify that all component controller pods in the applications namespace have a status of **Running** and their **Ready** condition is **True**.

   ```bash
   $ oc get pods -n redhat-ods-applications -o custom-columns='NAME:.metadata.name,READY:.status.conditions[?(@.type=="Ready")].status,STATUS:.status.phase'
   ```

   **Note**  
   If you are using a custom operator namespace, replace **redhat-ods-applications** with your application namespace.

5. Follow the Migration assessment script steps to run a final full cluster scan, and confirm that OpenShift AI is ready for the upgrade with the summary indicating that  Failed is 0\.

# 

# 

# **Chapter 3\. Upgrade to 3.5** {#chapter-3.-upgrade-to-3.3-(latest)}

## **3.1. OpenShift AI Operator**  {#3.1.-openshift-ai-operator}

After preparing your cluster and changing the subscription channel, you must manually approve the upgrade plan to begin the transition to the new version.

**Prerequisites**

* You have completed all the before upgrade tasks and verified that the cluster is ready for upgrade.

* Rerun the rh-ai  assessment script to make sure all critical issues are resolved.

* For disconnected environments, you have a mirror registry and oc-mirror v2, as described in [Mirroring images for a disconnected installation by using the oc-mirror plugin v2](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html/disconnected_environments/about-installing-oc-mirror-v2).

**Procedure**

1. You must log out of the OpenShift AI dashboard before starting the upgrade. OpenShift AI does not support Zero Downtime Upgrade.

   For connected environments, skip to Step 5\.

   For disconnected environments, continue to Step 2\.

2. For disconnected environments:

   Identify the OSSM version the Cluster Ingress Operator requires.  
   In the following steps, replace \<ossm-version\>  with this value (for example, servicemeshoperator3.v3.1.0):

   ```bash
   $ oc set env deployment/ingress-operator -n openshift-ingress-operator --list \
       | grep GATEWAY_API_OPERATOR_VERSION \
       | sed 's/.*=//'
   ```

3. Identify the OSSM channel the Cluster Ingress Operator uses to install OSSM.   
   In the following steps  replace \<ossm-channel\> with this value (for example,  stable):

   ```bash
   $ oc set env deployment/ingress-operator -n openshift-ingress-operator --list \
       | grep GATEWAY_API_OPERATOR_CHANNEL \
       | sed 's/.*=//'
   ```

### 

4. Mirror the exact OSSM version identified in Step 2 into the disconnected registry:  
   1. Create the ImageSetConfiguration. Replace \<ocp-version\>, \<ossm-version\> and \<ossm-channel\> with your values:

      ```bash
      $ cat > imageset-config.yaml <<EOF
      apiVersion: mirror.openshift.io/v2alpha1
      kind: ImageSetConfiguration
      mirror:
        operators:
          - catalog: registry.redhat.io/redhat/redhat-operator-index:v<ocp-version>
            packages:
              - name: servicemeshoperator3
                channels:
                  - name: <ossm-channel>
                    minVersion: <ossm-version>
                    maxVersion: <ossm-version>
      EOF
      ```

      

      **b.** Run oc-mirror to mirror the images. Replace \<mirror-registry\> with your registry URL:

      

      ```bash
      $ oc-mirror --v2 --config=imageset-config.yaml \
          --workspace file://oc-mirror-workspace \
          docker://<mirror-registry>
      ```

   

      **c.** If CatalogSource redhat-operators already exists on the cluster, skip this step and continue with step 4d  to verify that it references the version you just mirrored in step 4b. 

      If CatalogSource redhat-operators doesn’t exist on the cluster, change the name of the CatalogSource generated by oc-mirror to redhat-operators and apply the generated cluster resources so that  the cluster is aware of the mirrored content: 

   ```bash
   $ oc apply -f oc-mirror-workspace/working-dir/cluster-resources/
   ```

   

   **d.** Verify that the required version of OSSM is available in the required channel in the mirrored CatalogSource named redhat-operators:

   ```bash
   $ oc get packagemanifest -o json | jq '.items[] | select (.metadata.name == "servicemeshoperator3" and .status.catalogSource == "redhat-operators") | .status.channels[] | select (.name == "<ossm-channel>") | .entries[].name'
   ```

   

   The output should include the \<ossm-version\> from Step 2\. If it doesn’t include the version from Step 2, make sure that the CatalogSource named redhat-operators references it.

5. Log in to the OpenShift cluster web console as a cluster administrator.

6. In the Administrator perspective, in the left menu, select **Operators** \>  
    **Installed Operators**.

7. Click the **Red Hat OpenShift AI Operator**.

8. Click the **Subscription** tab.

9. For the **Upgrade channel**, select **support-required-upgrade**.

   **NOTE**:   
   Several other 3.x channels might be visible in the **Change Subscription update channels** list, such as fast-3.x, stable-3.5, and stable-3.x. However, these channels do not provide an upgrade from 2.25. Only the **support-required-upgrade** channel provides  an upgrade from 2.25.9 or later.

10. Approve the install plan to begin the upgrade.

1. In the **Upgrade status** section, click the "requires approval" link to approve the upgrade installation.  
2. Review the upgrade install plan details and click **Approve**. The upgrade process begins.

11. While the upgrade is in progress, monitor the following:

1. Watch the operator pods as they restart to replace the version 2.25.9 (and later) Operator.  
2. Verify that the new operator pods reach the **Running** state and that the **Ready** condition is **True**.

