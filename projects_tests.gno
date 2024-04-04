package zentasktic

import (
	"testing"

    "gno.land/p/demo/avl"
)

func Test_AddProject(t *testing.T) {
    
    project := Project{Id: "1", RealmId: "1", Body: "First project", ContextId: "1"}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    // Test adding a duplicate task.
    cerr := project.AddProject()
    if cerr != ErrProjectIdAlreadyExists {
        t.Errorf("Expected ErrProjectIdAlreadyExists, got %v", cerr)
    }
}


func Test_RemoveProject(t *testing.T) {
    
    project := Project{Id: "20", Body: "Removable project", RealmId: "1"}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    retrievedProject, rerr := GetProjectById(project.Id)
    if rerr != nil {
        t.Errorf("Could not retrieve the added project")
    }

    // Test removing a project
    terr := retrievedProject.RemoveProject()
    if terr != ErrProjectNotRemoved {
        t.Errorf("Expected ErrProjectNotRemoved, got %v", terr)
    }
}


func Test_EditProject(t *testing.T) {
    
    project := Project{Id: "2", Body: "Second project content", RealmId: "1", ContextId: "2"}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    // Test editing the project
    editedProject := Project{Id: project.Id, Body: "Edited project content", RealmId: project.RealmId, ContextId: "2"}
    cerr := editedProject.EditProject()
    if cerr != nil {
        t.Errorf("Failed to edit the project")
    }

    retrievedProject, _ := GetProjectById(editedProject.Id)
    if retrievedProject.Body != "Edited project content" {
        t.Errorf("Project was not edited")
    }
}


func Test_MoveProjectToRealm(t *testing.T) {
    
    project := Project{Id: "3", Body: "Project id 3 content", RealmId: "1", ContextId: "1"}

    // Test adding a project successfully.
    err := project.AddProject()
    if err != nil {
        t.Errorf("Failed to add project: %v", err)
    }

    // Test moving the project to another realm
    
    cerr := project.MoveProjectToRealm("2")
    if cerr != nil {
        t.Errorf("Failed to move project to another realm")
    }

    retrievedProject, _ := GetProjectById(project.Id)
    if retrievedProject.RealmId != "2" {
        t.Errorf("Project was moved to the wrong realm")
    }
}

/*
func Test_GetAllTasks(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    knownTasks := []Task{
        {Id: "1", RealmId: "1", Body: "First task", ContextId: "1",},
        {Id: "10", Body: "First content", RealmId: "2", ContextId: "2",},
        {Id: "2", Body: "Edited content", RealmId: "1", ContextId: "2",},
        {Id: "20", Body: "Removable task", RealmId: "1",},
        {Id: "3", Body: "First content", RealmId: "2", ContextId: "1",},
    }

    // Manually marshal the known tasks to create the expected outcome.
    tasksObject := TasksObject{Tasks: knownTasks}
    expected, err := tasksObject.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal known tasks: %v", err)
    }

    // Execute GetAllTasks() to get the actual outcome.
    actual, err := GetAllTasks()
    if err != nil {
        t.Fatalf("GetAllTasks() failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual task JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}*/

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
}
/*

func Test_GetTasksByRealm(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    tasksInAssessRealm := []Task{
        {Id: "1", RealmId: "1", Body: "First task", ContextId: "1",},
        {Id: "2", RealmId: "1", Body: "Edited content", ContextId: "2",},
        {Id: "20", Body: "Removable task", RealmId: "1",},
    }

    // Manually marshal the known tasks to create the expected outcome.
    tasksObjectAssess := TasksObject{Tasks: tasksInAssessRealm}
    expected, err := tasksObjectAssess.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal tasks in Assess: %v", err)
    }

    actual, err := GetTasksByRealm("1")
    if err != nil {
        t.Fatalf("GetTasksByRealm('1') failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual task JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}

func Test_GetTasksByContext(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    tasksInContextOne := []Task{
        {Id: "1", RealmId: "1", Body: "First task", ContextId: "1",},
        {Id: "3", RealmId: "2", Body: "First content", ContextId: "1",},
    }

    // Manually marshal the known tasks to create the expected outcome.
    tasksObjectForContexts := TasksObject{Tasks: tasksInContextOne}
    expected, err := tasksObjectForContexts.MarshalJSON()
    if err != nil {
        t.Fatalf("Failed to manually marshal tasks for ContextId 1: %v", err)
    }

    actual, err := GetTasksByContext("1")
    if err != nil {
        t.Fatalf("GetTasksByContext('1') failed with error: %v", err)
    }

    // Compare the expected and actual outcomes.
    if string(expected) != actual {
        t.Errorf("Expected and actual task JSON strings do not match.\nExpected: %s\nActual: %s", string(expected), actual)
    }
}
*/
