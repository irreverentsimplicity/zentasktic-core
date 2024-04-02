package zentasktic

import (
	"testing"

    "gno.land/p/demo/avl"
)

func Test_AddContext(t *testing.T) {
    
    context := Context{Id: "1", Name: "Work"}

    // Test adding a context successfully.
    err := context.AddContext()
    if err != nil {
        t.Errorf("Failed to add context: %v", err)
    }

    // Test adding a duplicate task.
    cerr := context.AddContext()
    if cerr != ErrContextIdAlreadyExists {
        t.Errorf("Expected ErrContextIdAlreadyExists, got %v", cerr)
    }
}

func Test_EditContext(t *testing.T) {
    
    context := Context{Id: "2", Name: "Home"}

    // Test adding a context successfully.
    err := context.AddContext()
    if err != nil {
        t.Errorf("Failed to add context: %v", err)
    }

    // Test editing the context
    editedContext := Context{Id: "2", Name: "Shopping"}
    cerr := editedContext.EditContext()
    if cerr != nil {
        t.Errorf("Failed to edit the context")
    }

    retrievedContext, _ := GetContextById(editedContext.Id)
    if retrievedContext.Name != "Shopping" {
        t.Errorf("Context was not edited")
    }
}

func Test_RemoveContext(t *testing.T) {
    
    context := Context{Id: "4", Name: "Gym"}

    // Test adding a context successfully.
    err := context.AddContext()
    if err != nil {
        t.Errorf("Failed to add context: %v", err)
    }

    // Test removing a context
    cerr := context.RemoveContext()
    if cerr != nil {
        t.Errorf("Expected ErrContextNotRemoved, got %v", cerr)
    }
}

func Test_AddContextToTask(t *testing.T) {

    //taskInAssess, _ := GetTaskById("1")
    /*
    taskInDecide, terr := GetTaskById("1")
    if terr != nil {
		t.Errorf("Could not get task by id 1")
	}
    
    contextToAdd, _ := GetContextById("2")
    */
    task := &Task{Id: "10", Body: "First content", RealmId: "2", ContextId: "1",}

    // Test adding a task successfully.
    err := task.AddTask()
    if err != nil {
        t.Errorf("Failed to add task: %v", err)
    }
    taskInDecide, exist := Tasks.Get("10")
	if !exist {
		t.Errorf("Task with id 1 not found")
	}
	// check if context exists
	contextToAdd, cexist := Contexts.Get("2")
	if !cexist {
		t.Errorf("Context with id 2 not found")
	}

    /*
    aerr := contextToAdd.AddContextToTask(taskInAssess)
    if aerr != ErrTaskNotEditable {
        t.Errorf("Expected ErrTaskNotEditable, got %v", aerr)
    }*/

    derr := contextToAdd.(Context).AddContextToTask(taskInDecide.(Task))
    if derr != nil {
        t.Errorf("Could not add context to a task in Decide, err %v", derr)
    }
}

/*

func Test_GetAllTasks(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    knownTasks := []Task{
        {Id: "1", RealmId: "1", Body: "First task", ContextId: "1",},
        {Id: "2", Body: "Edited content", RealmId: "1", ContextId: "2",},
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
}

func Test_GetTasksByRealm(t *testing.T) {
    
    // mocking the tasks based on previous tests
    // TODO: add isolation?
    tasksInAssessRealm := []Task{
        {Id: "1", RealmId: "1", Body: "First task", ContextId: "1",},
        {Id: "2", Body: "Edited content", RealmId: "1", ContextId: "2",},
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
        {Id: "3", Body: "First content", RealmId: "2", ContextId: "1",},
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
}*/ 
