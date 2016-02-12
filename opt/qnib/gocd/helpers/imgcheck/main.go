package main

import (
    "fmt"
    "os"
    "strings"
    "flag"

    "github.com/fsouza/go-dockerclient"
)

func main() {
    var compTag string
    flag.StringVar(&compTag, "tag", "latest", "Tag to compare the current ($GO_PIPELINE_COUNTER) tag against")
    flag.Parse()

    endpoint := os.Getenv("DOCKER_HOST")
    if endpoint == "" {
        endpoint = "unix:///var/run/docker.sock"
    }
    client, _ := docker.NewClient(endpoint)
    imgs, _ := client.ListImages(docker.ListImagesOptions{All: false})
    imgName := fmt.Sprintf("qnib/%s", os.Getenv("GO_PIPELINE_NAME"))
    nameArr := strings.Split(os.Getenv("GO_PIPELINE_NAME"), "_")
    if len(nameArr) == 2 {
        imgName = fmt.Sprintf("qnib/%s", nameArr[0])
    } else if len(nameArr) > 2 {
        fmt.Printf("Weird image name '%s'", os.Getenv("GO_PIPELINE_NAME"))
        os.Exit(1)
    }
    imgTag := fmt.Sprintf("%s_%s", compTag, os.Getenv("GO_PIPELINE_COUNTER"))
    var latest string
    var current string
    for _, img := range imgs {
        for _, repotag := range img.RepoTags {
            if strings.HasPrefix(repotag, imgName) {
                arr := strings.Split(repotag, ":")
                repo := arr[0]
                tag := arr[1]
                if repo == imgName {
                    if tag == compTag {
                        latest = img.ID
                    } else if tag == imgTag {
                        current = img.ID
                    }
                    fmt.Println("> RepoTag: ", repotag)
                    fmt.Println("ID: ", img.ID)
                    fmt.Println("Size: ", img.Size)
                }
            }
        }
    }
    if latest == current {
        fmt.Printf("FAIL > '%s' :  '%s'==%s !! Therefore we do not need to go on...\n", imgName, imgTag, compTag)
        os.Exit(1)
    } else {
        fmt.Printf("PASS > '%s' :  (%s)'%s'!=%s(%s)\n", imgName, latest, imgTag, compTag, current)
        os.Exit(0)
    }
}
