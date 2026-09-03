# Terraform Provisioning

## Introduction

This directory contains the Terraform stack that provisions the Autonomous Database and prepares the F1 ontology vector RAG workshop environment.

### Objectives

- Provision the 26ai Autonomous Database.
- Configure the workshop schema, RDF network, graph, and GenAI profiles.
- Prepare Graph Studio and Oracle JVM prerequisites.

Estimated Time: 10 minutes

## Task 1: Provision the workshop environment

1. Upload the Terraform archive for the selected authentication path to OCI Resource Manager.
2. Set the required tenancy, compartment, region, and reservation variables.
3. Apply the stack, then restart the Autonomous Database once when the output requests Oracle JVM enablement.
4. Open the generated SQL URL or Graph Studio URL and continue with the workshop labs.

## Acknowledgements

This provisioning guide is part of the F1 Ontology Vector RAG LiveLabs workshop.
