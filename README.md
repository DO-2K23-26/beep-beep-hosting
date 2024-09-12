# Beep Hosting

## Generating a secret from env file

Content of the .env file: 
```.env
postgres-password="cKKt916n/(5Knr1£$'v"
```
To generate a secret from this file:

```bash
kubectl create secret generic secret --from-env-file=./.env --dry-run=client -o yaml > secret.yaml
```

And you should have a correctly generated secret. 

## Generating and deploying sealed secret

You can quite simply install CRD's and bin following that [repo](https://github.com/bitnami-labs/sealed-secrets).

First create a classic kubernetes secret: 

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: pg-secret
type: Opaque
data:
  postgres-password: c2VjdXJlLXBhc3N3b3JkCg==
```

For the next step you must have access to the namespace you want to deploy your sealed secret.
We will next use the kubeseal command to generate the yaml file for the sealed secret like this:  

```bash
$ cat secret.yaml | kubeseal \
    --controller-namespace kube-system \
    --controller-name sealed-secrets-controller \
    --format yaml \
    --namespace infra \
    > sealed-secret.yaml
```

NOTICE: We are currently generating a file for the namespace "infra". If you omit this arg the secret will be created for the namespace default and will not be decoded once deployed.

The file "sealed-secret.yaml" is safe to be push on any public registry.

You can now apply this created sealed secret:

```bash
$ kubectl apply -f sealed-secret.yaml
sealedsecret.bitnami.com/pg-secret created
```

Well done ! You succesfully created a sealed secret. You can list it: 

```bash 
$ kubectl get sealedsecret -n infra
NAME        STATUS   SYNCED   AGE
pg-secret            True     75s
```
Futhermore a secret as been automatically created with the same name and same keys in the same namespace. Therefore you can use it like a normal secret. You can also list it:

```bash
$ kubectl get secret -n infra
NAME        TYPE     DATA   AGE
pg-secret   Opaque   1      8m21s
```

If you want to destroy this secret you must destroy the sealedsecret.
