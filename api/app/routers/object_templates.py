from fastapi import APIRouter, Security

from app.auth.security import get_current_active_user
from app.schemas import object_template as object_template_schemas
from app.schemas import user as user_schemas
from app.services.object_templates import get_local_object_templates

router = APIRouter()


@router.get(
    "/object-templates", response_model=list[object_template_schemas.ObjectTemplate]
)
def get_object_templates(
    user: user_schemas.User = Security(
        get_current_active_user, scopes=["objects:read"]
    ),
):
    return get_local_object_templates()
