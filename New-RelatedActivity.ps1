#based on Add-ActionLogEntry from https://github.com/AdhocAdam/smletsexchangeconnector

function New-RelatedActivity {
    param(
        $Parent, $ActivityClass, $Prefix, $Title
    )

    switch ($Parent.ClassName)
    {
        "System.WorkItem.Incident" {$className = "Activity"}
        "System.WorkItem.ServiceRequest" {$className = "Activity"}
        "System.WorkItem.ChangeRequest" {$className = "Activities"}
        "System.WorkItem.Activity.ParallelActivity" {$className = "Activities"}
    }

    $Projection = @{
        __CLASS = "$($parent.ClassName)";
        __SEED = $Parent;
        $className = @{
            __CLASS = $ActivityClass.Name;
            __OBJECT = @{
                Id = "$Prefix{0}"
                Title = "$Title"
            }
        }
    }
    switch ($Parent.ClassName)
    {
        "System.WorkItem.Incident" {New-SCSMObjectProjection -Type "System.WorkItem.IncidentPortalProjection$" -Projection $Projection -PassThru -Bulk}
        "System.WorkItem.ServiceRequest" {New-SCSMObjectProjection -Type "System.WorkItem.ServiceRequestPortalProjection$" -Projection $Projection -PassThru -Bulk }
        "System.WorkItem.ChangeRequest" {New-SCSMObjectProjection -Type "TypeProjection.ChangeRequest$" -Projection $Projection -PassThru -Bulk }
        "System.WorkItem.Activity.ParallelActivity" {New-SCSMObjectProjection -Type "TypeProjection.ParallelActivity$" -Projection $Projection -PassThru -Bulk}
    }
}
