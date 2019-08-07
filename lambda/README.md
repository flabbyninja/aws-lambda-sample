# Lambda Development and Packaging for Python

## Initialisation
Prepare environment with helpers to allow easy build, test and deployment of Python lambdas


```
python -m virtualenv venv
source venv/Scripts/activate
pip install python-lambda
```

The features of `python-lambda` are described at [here](https://github.com/nficano/python-lambda)

## Testing
Test mocked events using 
`lambda invoke`. 

By default this will load `event.json`. You can pass specific JSON files using

`lambda invoke --event-file=new_event.json`

## Packaging and Deploy

TBD