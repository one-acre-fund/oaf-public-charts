# Add repo and image tag for the BE and FE images in ci-values.yaml

```
fineract_backend:
  image:
    name: ""
    tag: ""

fineract_frontend:
  image:
    name: ""
    tag: ""

```
# Add database details in ci-values.yaml

```
fineract_db:
  HOSTNAME: ""
  USERNAME: ""
  PASSWORD: ""
```
# To install fineract
    helm upgrade --install fineract . -f "ci/qa.yaml"

# To uninstall fineract
    helm uninstall fineract