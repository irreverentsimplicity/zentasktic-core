package zentasktic_core

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/ufmt"
    "gno.land/p/demo/avl"
)

var (
    Tasks *avl.Tree = avl.NewTree() // Ensure Tasks is initialized for testing
)


func TestAddTask(t *testing.T) {
    Tasks = avl.NewTree()
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
