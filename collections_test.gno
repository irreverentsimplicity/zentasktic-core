package zentasktic

import (
	"testing"

    "gno.land/p/demo/avl"
)

func Test_AddCollection(t *testing.T) {
    
    collection := Collection{Id: "1", RealmId: "4", Name: "First collection",}

    // Test adding a collection successfully.
    err := collection.AddCollection()
    if err != nil {
        t.Errorf("Failed to add collection: %v", err)
    }

    // Test adding a duplicate task.
    cerr := collection.AddCollection()
    if cerr != ErrCollectionIdAlreadyExists {
        t.Errorf("Expected ErrCollectionIdAlreadyExists, got %v", cerr)
    }
}


func Test_RemoveCollection(t *testing.T) {
    
    collection := Collection{Id: "20", RealmId: "4", Name: "Removable collection",}

    // Test adding a collection successfully.
    err := collection.AddCollection()
    if err != nil {
        t.Errorf("Failed to add collection: %v", err)
    }

    retrievedCollection, rerr := GetCollectionById(collection.Id)
    if rerr != nil {
        t.Errorf("Could not retrieve the added collection")
    }

    // Test removing a collection
    terr := retrievedCollection.RemoveCollection()
    if terr != ErrCollectionNotRemoved {
        t.Errorf("Expected ErrCollectionNotRemoved, got %v", terr)
    }
}


func Test_EditCollection(t *testing.T) {
    
    collection := Collection{Id: "2", RealmId: "4", Name: "Second collection",}

    // Test adding a collection successfully.
    err := collection.AddCollection()
    if err != nil {
        t.Errorf("Failed to add collection: %v", err)
    }

    // Test editing the collection
    editedCollection := Collection{Id: collection.Id, RealmId: collection.RealmId, Name: "Edited collection",}
    cerr := editedCollection.EditCollection()
    if cerr != nil {
        t.Errorf("Failed to edit the collection")
    }

    retrievedCollection, _ := GetCollectionById(editedCollection.Id)
    if retrievedCollection.Name != "Edited collection" {
        t.Errorf("Collection was not edited")
    }
}

func Test_AddProjectToCollection(t *testing.T){
    // Example Collection and Projects
    col := Collection{Id: "1", Name: "Collection 1", RealmId: "4",}
    prj := Project{Id: "10", Body: "Project 10", RealmId: "1",}

    Collections.Set(col.Id, col) // Mock existing collections

    tests := []struct {
        name    string
        collection Collection
        project    Project
        wantErr bool
        errMsg  error
    }{
        {
            name:    "Attach to existing collection",
            collection: col,
            project:    prj,
            wantErr: false,
        },
        {
            name:    "Attach to non-existing collection",
            collection: Collection{Id: "200", Name: "Collection 200", RealmId: "4",},
            project:    prj,
            wantErr: true,
            errMsg:  ErrCollectionIdNotFound,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := tt.collection.AddProjectToCollection(tt.project)
            if (err != nil) != tt.wantErr {
                t.Errorf("AddProjectToCollection() error = %v, wantErr %v", err, tt.wantErr)
            }
            if tt.wantErr && err != tt.errMsg {
                t.Errorf("AddProjectToCollection() error = %v, expected %v", err, tt.errMsg)
            }

            // For successful attach, verify the project is added to the collection's tasks.
            if !tt.wantErr {
                projects, exist := CollectionProjects.Get(tt.collection.Id)
                if !exist || len(projects.([]Project)) == 0 {
                    t.Errorf("Project was not added to the collection")
                } else {
                    found := false
                    for _, project := range projects.([]Project) {
                        if project.Id == tt.project.Id {
                            found = true
                            break
                        }
                    }
                    if !found {
                        t.Errorf("Project was not attached to the collection")
                    }
                }
            }
        })
    }
}

func Test_AddTaskToCollection(t *testing.T){
    // Example Collection and Projects
    col := Collection{Id: "2", Name: "Collection 2", RealmId: "4",}
    tsk := Task{Id: "10", Body: "Task 10", RealmId: "1",}

    Collections.Set(col.Id, col) // Mock existing collections

    tests := []struct {
        name    string
        collection Collection
        task    Task
        wantErr bool
        errMsg  error
    }{
        {
            name:    "Attach to existing collection",
            collection: col,
            task:    tsk,
            wantErr: false,
        },
        {
            name:    "Attach to non-existing collection",
            collection: Collection{Id: "210", Name: "Collection 210", RealmId: "4",},
            task:    tsk,
            wantErr: true,
            errMsg:  ErrCollectionIdNotFound,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := tt.collection.AddTaskToCollection(tt.task)
            if (err != nil) != tt.wantErr {
                t.Errorf("AddTaskToCollection() error = %v, wantErr %v", err, tt.wantErr)
            }
            if tt.wantErr && err != tt.errMsg {
                t.Errorf("AddTaskToCollection() error = %v, expected %v", err, tt.errMsg)
            }

            // For successful attach, verify the task is added to the collection's tasks.
            if !tt.wantErr {
                tasks, exist := CollectionTasks.Get(tt.collection.Id)
                if !exist || len(tasks.([]Task)) == 0 {
                    t.Errorf("Task was not added to the collection")
                } else {
                    found := false
                    for _, task := range tasks.([]Task) {
                        if task.Id == tt.task.Id {
                            found = true
                            break
                        }
                    }
                    if !found {
                        t.Errorf("Task was not attached to the collection")
                    }
                }
            }
        })
    }
}





