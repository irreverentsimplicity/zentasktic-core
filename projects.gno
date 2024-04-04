// base implementation
package zentasktic

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
)


type Project struct {
	Id 			string `json:"projectId"`
	ContextId	string `json:"projectContextId"`
	RealmId 	string `json:"projectRealmId"`
	Tasks		[]Task `json:"projectTasks"`
	Body 		string `json:"projectBody"`
	Due			string `json:"ProjectDue"`
}

var (
	Projects avl.Tree // projectId -> Project
	ProjectTasks avl.Tree // projectId -> []Task
)

// actions

func (p Project) AddProject() (err error) {
	// implementation
	
	if Projects.Size() != 0 {
		existingProject, exist := Projects.Get(p.Id)
		if exist {
			return ErrProjectIdAlreadyExists
		}
	}
	Projects.Set(p.Id, p)
	return nil
}

func (p Project) RemoveProject() (err error) {
	// implementation, remove from ProjectTasks too
	existingProject := Project{}
	existingProjectTasks := []Task

	if Projects.Size() != 0 {
		existingProject, exist := Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
	}
	
	// project is removable only in Asses (RealmId 1) or via a Collection (RealmId 4)
	if p.RealmId != "1" && p.RealmId != "4" {
		return ErrProjectNotRemovable
	}

	_, removed := Projects.Remove(existingProject.Id)
	if !removed {
		return ErrProjectNotRemoved
	}

	// manage project tasks, if any

	if ProjectTasks.Size() != 0 {
		existingProjectTasks, exist := ProjectTasks.Get(existingProject.Id)
		if !exist {
			// if there's no record in ProjectTasks, we don't have to remove anything
			return nil
		} else {
			_, removed := ProjectTasks.Remove(existingProject.Id)
			if !removed {
				return ErrProjectTasksNotRemoved
			}
		}
	}

	return nil
}

func (p Project) EditProject() (err error) {
	// implementation, get project by Id and replace the object
	// this is for the project body and realm, project tasks are managed in the Tasks object
	existingProject := Project{}
	if Projects.Size() != 0 {
		existingProject, exist := Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
	}
	
	// project Body is editable only when project is in Assess, RealmId = "1"
	if p.RealmId != "1" {
		if p.Body != existingProject.Body {
			return ErrProjectNotInAssessRealm
		}
	}

	Projects.Set(p.Id, p)
	return nil
}

// helper function, we can achieve the same with EditProject() above
func (p Project) MoveProjectToRealm(realmId string) (err error) {
	// implementation
	if Projects.Size() != 0 {
		existingProject, exist := Projects.Get(p.Id)
		if !exist {
			return ErrProjectIdNotFound
		}
		existingProject.(Project).RealmId = realmId
		Projects.Set(p.Id, existingProject)
	}
	return nil
}

func (p Project) GetProjectTasks() (tasks []Task, err error) {
	// implementation, query ProjectTasks and return the []Tasks object
	existingProjectTasks := []Task

	if ProjectTasks.Size() != 0 {
		existingProjectTasks, exist := ProjectTasks.Get(p.Id)
		if !exist {
			// if there's no record in ProjectTasks, we don't have to return anything
			return nil, ErrProjectTasksNotFound
		} else {
			return existingProjectTasks.([]Task), nil
		}
	}
	return nil, nil
}

// getters

func GetProjectById(projectId string) (p Project, err error) {
	if Projects.Size() != 0 {
		p, exist := Projects.Get(projectId)
		if exist {
			return p.(Project), nil
		} else {
			return nil, ErrProjectByIdNotFound
		}
	}
}

func GetAllProjects() (projects string, err error) {
	// implementation
	var allProjects []Project
	
	// Iterate over the Projects AVL tree to collect all Project objects.
	
	Projects.Iterate("", "", func(key string, value interface{}) bool {
		if project, ok := value.(Project); ok {
			// get project tasks, if any
			projectTasks, err := project.GetProjectTasks()
			if projectTasks != nil {
				project.Tasks = projectTasks
			}
			allProjects = append(allProjects, project)
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: allProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil
}

func GetProjectsByRealm(realmId string) (projects string, err error) {
	// implementation
	var realmProjects []Project
	
	// Iterate over the Projects AVL tree to collect all Project objects.
	
	Projects.Iterate("", "", func(key string, value interface{}) bool {
		if project, ok := value.(Project); ok {
			if project.RealmId == realmId {
				// get project tasks, if any
				projectTasks, err := project.GetProjectTasks()
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				realmProjects = append(realmProjects, project)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: realmProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil
}

func GetProjectsByContext(contextId string) (projects string, err error) {
	// implementation
	var contextProjects []Project
	
	// Iterate over the Projects AVL tree to collect all Project objects.
	
	Projects.Iterate("", "", func(key string, value interface{}) bool {
		if project, ok := value.(Project); ok {
			if project.ContextId == contextId {
				// get project tasks, if any
				projectTasks, err := project.GetProjectTasks()
				if projectTasks != nil {
					project.Tasks = projectTasks
				}
				contextProjects = append(contextProjects, project)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a ProjectsObject with all collected tasks.
	projectsObject := ProjectsObject{
		Projects: contextProjects,
	}

	// Use the custom MarshalJSON method to marshal the tasks into JSON.
	marshalledProjects, merr := projectsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledProjects), nil
}

func GetProjectsByDate(date string) (projects string, err error) {
	// implementation
}
