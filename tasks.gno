package zentasktic

import (
	"strconv"
	"errors"
	"time"

	"gno.land/p/demo/avl"
)

type Task struct {
	Id 			string `json:"taskId"`
	ProjectId 	string `json:"taskProjectId"`
	ContextId	string `json:"taskContextId"`
	RealmId 	string `json:"taskRealmId"`
	Body 		string `json:"taskBody"`
	Due			string `json:"taskDue"`
	Alert		string `json:"taskAlert"`
}

var (
	Tasks avl.Tree // taskId -> Task
)

// actions

func (t Task) AddTask() (err error) {
	// implementation
	
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if exist {
			return ErrTaskIdAlreadyExists
		}
	}
	Tasks.Set(t.Id, t)
	return nil
}

func (t Task) RemoveTask() (err error) {
	// implementation
	existingTask := Task{}
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if !exist {
			return ErrTaskIdNotFound
		}
	}
	
	// task is removable only in Asses (RealmId 1) or via a Collection (RealmId 4)
	if t.RealmId != "1" && t.RealmId != "4" {
		return ErrTaskNotRemovable
	}

	_, removed := Tasks.Remove(existingTask.Id)
	if !removed {
		return ErrTaskNotRemoved
	}
	return nil
}


func (t Task) EditTask() (err error) {
	// implementation, get task by Id and replace the object
	existingTask := Task{}
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if !exist {
			return ErrTaskIdNotFound
		}
	}
	
	// task Body is editable only when task is in Assess, RealmId = "1"
	if t.RealmId != "1" {
		if t.Body != existingTask.Body {
			return ErrTaskNotInAssessRealm
		}
	}

	Tasks.Set(t.Id, t)
	return nil
}

// helper function, we can achieve the same with EditTask() above
func (t Task) MoveTaskToRealm(realmId string) (err error) {
	// implementation
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if !exist {
			return ErrTaskIdNotFound
		}
		existingTask.(Task).RealmId = realmId
		Tasks.Set(t.Id, existingTask)
	}
	return nil
}


func (t Task) AttachTaskToProject(p Project) (err error) {
	// implementation
	if Projects.Size() != 0 {
		existingProject, exist := Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
	}

	existingProjectTasks, texist := ProjectTasks.Get(p.Id)
	if !texist {
		// If the project has no tasks yet, initialize the slice.
		existingProjectTasks = []Task{}
	} else {
		tasks, ok := existingProjectTasks.([]Task)
		if !ok {
			return ErrProjectTasksNotFound
		}
		existingProjectTasks = tasks
	}
	t.ProjectId = p.Id
	t.EditTask()
	updatedTasks := append(existingProjectTasks.([]Task), t)

	ProjectTasks.Set(p.Id, updatedTasks)

	return nil
}

func (t Task) DetachTaskFromProject(p Project) (err error) {
	// implementation
	if Projects.Size() != 0 {
		existingProject, exist := Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
	}

	existingProjectTasks, texist := ProjectTasks.Get(p.Id)
	if !texist {
		// If the project has no tasks yet, return appropriate error
		return ErrProjectTasksNotFound
	}

	// Find the index of the task to be removed.
	var index int = -1
	for i, task := range existingProjectTasks.([]Task) {
		if task.Id == t.Id {
			index = i
			break
		}
	}

	// If the task was found, we remove it from the slice.
	if index != -1 {
		existingProjectTasks = append(existingProjectTasks.([]Task)[:index], existingProjectTasks.([]Task)[index+1:]...)
	} else {
		// Task not found in the project
		return ErrTaskByIdNotFound 
	}
	t.ProjectId = ""
	t.EditTask()
	ProjectTasks.Set(p.Id, existingProjectTasks)

	return nil
}

func (t Task) SeTaskDueDate(dueDate string) (err error) {
	// implementation
	// check if task exists
	task, exist := Tasks.Get(t.Id)
	if !exist {
		return ErrTaskIdNotFound
	}

	// check to see if task is in RealmId = 2 (Decide)
	// we can only add resources in Decide
	if t.RealmId == "2" {
		task.(Task).Due = dueDate
		Tasks.Set(t.Id, task.(Task))
	} else {
		return ErrTaskNotEditable
	}

	return nil
}

func (t Task) SetTaskAlert(alertDate string) (err error) {
	// check if task exists
	task, exist := Tasks.Get(t.Id)
	if !exist {
		return ErrTaskIdNotFound
	}

	// check to see if task is in RealmId = 2 (Decide)
	// we can only add resources in Decide
	if t.RealmId == "2" {
		task.(Task).Alert = alertDate
		Tasks.Set(t.Id, task.(Task))
	} else {
		return ErrTaskNotEditable
	}

	return nil
}
// getters

func GetTaskById(taskId string) (t Task, err error) {
	if Tasks.Size() != 0 {
		t, exist := Tasks.Get(taskId)
		if exist {
			return t.(Task), nil
		} else {
			return nil, ErrTaskByIdNotFound
		}
	}
}

func GetAllTasks() (tasks string, err error) {
	// implementation
	var allTasks []Task

	// Iterate over the Tasks AVL tree to collect all Task objects.
	Tasks.Iterate("", "", func(key string, value interface{}) bool {
		if task, ok := value.(Task); ok {
			allTasks = append(allTasks, task)
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a TasksObject with all collected tasks.
	tasksObject := &TasksObject{
		Tasks: allTasks,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledTasks, merr := tasksObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledTasks), nil
}

func GetTasksByRealm(realmId string) (tasks string, err error) {
	// implementation
	var realmTasks []Task

	// Iterate over the Tasks AVL tree to collect all Task objects.
	
	Tasks.Iterate("", "", func(key string, value interface{}) bool {
		if task, ok := value.(Task); ok {
			if task.RealmId == realmId {
				realmTasks = append(realmTasks, task)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a TasksObject with all collected tasks.
	tasksObject := TasksObject{
		Tasks: realmTasks,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledTasks, merr := tasksObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledTasks), nil
}

func GetTasksByContext(contextId string) (tasks string, err error) {
	// implementation
	var contextTasks []Task

	// Iterate over the Tasks AVL tree to collect all Task objects.
	
	Tasks.Iterate("", "", func(key string, value interface{}) bool {
		if task, ok := value.(Task); ok {
			if task.ContextId == contextId {
				contextTasks = append(contextTasks, task)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a TasksObject with all collected tasks.
	tasksObject := TasksObject{
		Tasks: contextTasks,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledTasks, merr := tasksObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledTasks), nil
}

func GetTasksByDate(taskDate string, filterType string) (tasks string, err error) {
	// implementation
	parsedDate, err:= time.Parse("2006-01-02", taskDate)
	if err != nil {
		return "", ErrInvalidateDateFormat
	}

	var filteredTasks []Task
	
	Tasks.Iterate("", "", func(key string, value interface{}) bool {
		task, ok := value.(Task)
		if !ok {
			return true // Skip this iteration and continue.
		}

		storedDate, serr := time.Parse("2006-01-02", task.Due)
		if serr != nil {
			// Skip tasks with invalid dates.
			return true
		}

		switch filterType {
		case "specific":
			if storedDate.Format("2006-01-02") == parsedDate.Format("2006-01-02") {
				filteredTasks = append(filteredTasks, task)
			}
		case "before":
			if storedDate.Before(parsedDate) {
				filteredTasks = append(filteredTasks, task)
			}
		case "after":
			if storedDate.After(parsedDate) {
				filteredTasks = append(filteredTasks, task)
			}
		}

		return false // Continue iteration.
	})

	if len(filteredTasks) == 0 {
		return "", nil
	}

	// Create a TasksObject with all collected tasks.
	tasksObject := TasksObject{
		Tasks: filteredTasks,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledTasks, merr := tasksObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledTasks), nil
}
