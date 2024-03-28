package zentasktic_core

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/ufmt"
)


func TestAddTask(t *testing.T) {
    
    task := Task{Id: "task1", RealmId: "realm1"}

    // Test adding a task successfully.
    err := task.AddTask()
    if err != nil {
        t.Errorf("Failed to add task: %v", err)
    }

    // Test adding a duplicate task.
    err = task.AddTask()
    if err != ErrTaskIdAlreadyExists {
        t.Errorf("Expected ErrTaskIdAlreadyExists, got %v", err)
    }
}
