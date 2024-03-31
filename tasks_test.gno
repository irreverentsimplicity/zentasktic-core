package zentasktic

import (
	"testing"

    "gno.land/p/demo/avl"
)

func Test_AddTask(t *testing.T) {
    
    task := Task{Id: "1", RealmId: "1", Body: "First task",}

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
    
    task := Task{Id: "3", Body: "First content", RealmId: "1"}

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

func TestDetachTaskFromProject(t *testing.T) {
	
	// Setup:
	project := Project{Id: "p1", Body: "Test Project"}
	task1 := Task{Id: "5", Body: "Task One"}
	task2 := Task{Id: "6", Body: "Task Two"}

	Projects.Set(project.Id, project)
	ProjectTasks.Set(project.Id, []Task{task1, task2})

	tests := []struct {
		name       string
		task       Task
		project    Project
		wantErr    bool
		expectedErr error
	}{
		{
			name:       "Detach existing task from project",
			task:       task1,
			project:    project,
			wantErr:    false,
			expectedErr: nil,
		},
		{
			name:       "Try to detach task from non-existing project",
			task:       task1,
			project:    Project{Id: "nonexistent"},
			wantErr:    true,
			expectedErr: ErrProjectIdNotFound,
		},
		{
			name:       "Try to detach non-existing task from project",
			task:       Task{Id: "nonexistent"},
			project:    project,
			wantErr:    true,
			expectedErr: ErrTaskByIdNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := tt.task.DetachTaskFromProject(tt.project)

			if tt.wantErr {
				if err == nil || err != tt.expectedErr {
					t.Errorf("%s: expected error %v, got %v", tt.name, tt.expectedErr, err)
				}
			} else {
				if err != nil {
					t.Errorf("%s: unexpected error: %v", tt.name, err)
				}

				// For successful detachment, verify the task is no longer part of the project's tasks
				if !tt.wantErr {
					tasks, _ := ProjectTasks.Get(tt.project.Id)
					for _, task := range tasks.([]Task) {
						if task.Id == tt.task.Id {
							t.Errorf("%s: task was not detached from the project", tt.name)
							break
						}
					}
				}
			}
		})
	}
}

func Test_GetAllTasks(t *testing.T) {
    
    knownTasks := []Task{
        {Id: "1", RealmId: "1", Body: "First task"},
        {Id: "2", Body: "First content", RealmId: "1"},
        {Id: "3", Body: "Edited content", RealmId: "1"},
    }

    /*
    for _, task := range knownTasks {
        //Tasks.Set(task.Id, task)
        task.AddTask()
    }*/

    // Verify that both tasks have been added.
    if Tasks.Size() != len(knownTasks) {
        t.Errorf("Expected AVL tree size to be %d, got %d", len(knownTasks), Tasks.Size())
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