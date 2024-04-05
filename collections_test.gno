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

/*
func Test_GetAllProjects(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    knownProjects := []Project{
        {Id: "1", Body: "First project", RealmId: "1", ContextId: "1",},
		{Id: "2", Body: "Edited project content", RealmId: "1", ContextId: "2",},
        {Id: "20", Body: "Removable project", RealmId: "1", ContextId: "2",},
		{Id: "3", Body: "Project id 3 content", RealmId: "2", ContextId: "1",},
    }

    // Manually marshal the known projects to create the expected outcome.
    projectsObject := ProjectsObject{Projects: knownProjects}
    expected, err := projectsObject.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal known projects: %v", err)
    }

    // Execute GetAllProjects() to get the actual outcome.
    actual, err := GetAllProjects()
    if err != nil {
        t.Fatalf("GetAllProjects() failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual project JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}

func Test_GetProjectTasks(t *testing.T){
    
    task := Task{Id: "1", RealmId: "1", Body: "First task", ContextId: "1",}

    project, perr := GetProjectById("1")
    if perr != nil {
        t.Errorf("GetProjectById() failed, %v", perr)
    }

    // test attaching to an existing project
    atterr := task.AttachTaskToProject(project)
    if atterr != nil {
        t.Errorf("AttachTaskToProject() failed, %v", atterr)
    }

    projectTasks, pterr := project.GetProjectTasks()
    if len(projectTasks) == 0 {
        t.Errorf("GetProjectTasks() failed, %v", pterr)
    }

    // test detaching from an existing project
    dtterr := task.DetachTaskFromProject(project)
    if dtterr != nil {
        t.Errorf("DetachTaskFromProject() failed, %v", dtterr)
    }

    projectWithNoTasks, pterr := project.GetProjectTasks()
    if len(projectWithNoTasks) != 0 {
        t.Errorf("GetProjectTasks() after detach failed, %v", pterr)
    }
}

func Test_GetProjectById(t *testing.T){
    // test getting a non-existing project
    nonProject, err := GetProjectById("0")
    if err != ErrProjectByIdNotFound {
        t.Fatalf("Expected ErrProjectByIdNotFound, got: %v", err)
    }

    // test getting the correct task by id
    correctProject, err := GetProjectById("1")
    if err != nil {
        t.Fatalf("Failed to get project by id, error: %v", err)
    }

    if correctProject.Body != "First project" {
        t.Fatalf("Got the wrong project, with body: %v", correctProject.Body)
    }
}*/



