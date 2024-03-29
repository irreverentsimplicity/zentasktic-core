package zentasktic

import (
	"testing"

    "gno.land/p/demo/avl"
)

func Test_AddTask(t *testing.T) {
    
    task := Task{Id: "1", RealmId: "1"}

    // Test adding a task successfully.
    err := task.AddTask()
    if err != nil {
        t.Errorf("Failed to add task: %v", err)
    }

    // Test adding a duplicate task.
    cerr := task.AddTask()
    if cerr != ErrTaskIdAlreadyExists {
        t.Errorf("Expected ErrTaskIdAlreadyExists, got %v", cerr)
    }
}


func Test_EditTask(t *testing.T) {
    
    task := Task{Id: "2", Body: "First content", RealmId: "1"}

    // Test adding a task successfully.
    err := task.AddTask()
    if err != nil {
        t.Errorf("Failed to add task: %v", err)
    }

    // Test editing the task
    editedTask := Task{Id: task.Id, Body: "Edited content", RealmId: task.RealmId}
    cerr := editedTask.EditTask()
    if cerr != nil {
        t.Errorf("Failed to edit the task")
    }

    retrievedTask, _ := GetTaskById(editedTask.Id)
    if retrievedTask.Body != "Edited content" {
        t.Errorf("Task was not edited")
    }
}

func Test_MoveTaskToRealm(t *testing.T) {
    
    task := Task{Id: "4", Body: "First content", RealmId: "1"}

    // Test adding a task successfully.
    err := task.AddTask()
    if err != nil {
        t.Errorf("Failed to add task: %v", err)
    }

    // Test moving the task to another realm
    
    cerr := task.MoveTaskToRealm("2")
    if cerr != nil {
        t.Errorf("Failed to move task to another realm")
    }

    retrievedTask, _ := GetTaskById(task.Id)
    if retrievedTask.RealmId != "2" {
        t.Errorf("Task was moved to the wrong realm")
    }
}
