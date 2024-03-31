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


func Test_AttachTaskToProject(t *testing.T) {
    // Initialize or mock Projects and ProjectTasks AVL trees
    //Projects := avl.NewTree()
    //ProjectTasks := avl.NewTree()

    // Example Projects and Tasks
    prj := Project{Id: "1", Body: "Project 1", RealmId: "1"}
    tsk := Task{Id: "4", Body: "Task 4", RealmId: "1"}

    Projects.Set(prj.Id, prj) // Mock existing project

    tests := []struct {
        name    string
        project Project
        task    Task
        wantErr bool
        errMsg  error
    }{
        {
            name:    "Attach to existing project",
            project: prj,
            task:    tsk,
            wantErr: false,
        },
        {
            name:    "Attach to non-existing project",
            project: Project{Id: "2", Body: "Project 2"},
            task:    tsk,
            wantErr: true,
            errMsg:  ErrProjectIdNotFound,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := tt.task.AttachTaskToProject(tt.project)
            if (err != nil) != tt.wantErr {
                t.Errorf("AttachTaskToProject() error = %v, wantErr %v", err, tt.wantErr)
            }
            if tt.wantErr && err != tt.errMsg {
                t.Errorf("AttachTaskToProject() error = %v, expected %v", err, tt.errMsg)
            }

            // For successful attach, verify the task is added to the project's tasks.
            if !tt.wantErr {
                tasks, exist := ProjectTasks.Get(tt.project.Id)
                if !exist || len(tasks.([]Task)) == 0 {
                    t.Errorf("Task was not attached to the project")
                } else {
                    found := false
                    for _, task := range tasks.([]Task) {
                        if task.Id == tt.task.Id {
                            found = true
                            break
                        }
                    }
                    if !found {
                        t.Errorf("Task was not attached to the project")
                    }
                }
            }
        })
    }
}
