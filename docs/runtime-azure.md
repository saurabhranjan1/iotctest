# Cost estimation of runtime in the Azure Container Instances

As long the IoTC is running in the ACI it is subject to repeated cost. The fee depends on the kind of Azure Subscription you have and the consumed resources of the IoTC.

## Azure subscriptions
Azure offers different [subscription models](https://cloudacademy.com/course/understanding-azure-pricing-and-support/azure-subscriptions/). It is important to consider the correct model for your operation as there are considerable differences in the cost model.

The pay-as-you-go [subscription](https://azure.microsoft.com/en-us/offers/ms-azr-0003p/) lets you pay for the services and resources that you use on a monthly basis. A credit or debit card must be attached to the account, and billing for this account is on a monthly basis.

Microsoft has many types of [member offers](https://azure.microsoft.com/en-us/support/legal/offer-details/) that offer reduced rates for Azure services, like MSDN Platform subscribers and Visual Studio subscribers, to name a few. These types of subscriptions offer substantial discounts over a pay-as-you-go subscription, so it is highly recommended that businesses review and take advantage of any offers for which they may qualify.

### Limits of websocket connections
Based on the selected subscription model, there might be set limits for maximum parallel websocket connections (APs). Please confirm the [quotas](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) for your deployment with Microsoft when planning a commercial usage.

## Specify consumed resources
In the docker compose files, you can specify the `reserved` (minimum) and the `limits` (maximum) of [resources allocated](https://docs.docker.com/compose/compose-file/compose-file-v3/#deploy) for containers inside your group at deployment.

Example:

````yaml
    version: "3.9"
    services:
    redis:
        image: redis:alpine
        deploy:
        resources:
            limits:
                cpus: '0.50'
                memory: 50M
            reservations:
                cpus: '0.25'
                memory: 20M

````

ACI will [consider](https://docs.docker.com/cloud/ecs-compose-features/#container-resources) this deploy features.

We have entered the typical values in the azure deployment file `/deploy/azure_deployment/docker-compose.yml`. Feel free to edit them based on your considerations. A benchmark for performance tests at specified values can be found [here](./runtime-performance.md#load-tests-in-azure)

### Track consumption of resources

You can track the actual consumption of your resources with the Azure [container monitor](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-monitor) and adjust it for your use case and cost plans accordingly. Using the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) you can also get individual container consumption from the container group, which is much more precise. e.g., use the following command for average CPU Usage:

````shell
az monitor metrics list --resource (az container show --resource-group **your-resource-group** --name **your-container-group-name** --query id --output tsv) --metric CPUUsage --dimension containerName --output table
````

Read the Azure [documentation](https://docs.microsoft.com/en-US/cli/azure/monitor/metrics?view=azure-cli-latest#az_monitor_metrics_list) for detailed options on the command.

## Azure cost calculation

When running the IoTC in Azure, the costs can be evaluated with the Azure [cost calculator](https://azure.microsoft.com/en-us/pricing/calculator/) for **Azure Container Instances**.

Permanent storage or additional components, e.g., Azure Io Hub, need to be considered in pricing separately.

### Typical Parameters for calculation

|  Parameter  |  Typical Value  |  Notes  |
|--------|--------|--------|
|Container Groups|1|Assuming you deployed one IoTC|
|Duration|30 days|How long will the container group (IoTC) run per month|
|vCPU|1|How many CPU cores will the container group (IoTC) consume in sum. This depends on what you have specified as [reserved and limit](#specify-resources-reservation-limits) in the compose file for each container. If the sum of the reservations is bigger than 1, then the group will constantly consume 2 vCPU, which will effectively double the cost. A benchmark for performance tests can be found [here](./runtime-performance.md#load-tests-in-azure) |
|Memory|2GB|Consumed RAM This depends on what you have specified as [reserved and limit].|
