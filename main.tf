terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.11.1"
    }
  }
  required_version = ">= 0.13"
}

resource "mongodbatlas_project" "testProject" {
  name   = "TestDemo"
  org_id = "Add your ORG-ID"
}

resource "mongodbatlas_project_ip_access_list" "testIpAccessList" {
  project_id = mongodbatlas_project.testProject.id
  ip_address = "ADD YOUR IP ADDRESS"
}

resource "mongodbatlas_database_user" "testUser" {
  username           = "User1"
  password           = "Password1"
  project_id         = mongodbatlas_project.testProject.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }
}

resource "mongodbatlas_advanced_cluster" "test" {
  project_id   = mongodbatlas_project.testProject.id
  name         = "ClusterDemo"
  cluster_type = "REPLICASET"

  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M0"
      }
      provider_name         = "TENANT"
      backing_provider_name = "AWS"
      region_name           = "US_EAST_1"
      priority              = 7
    }
  }
}
