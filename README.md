# imaginamos Prueba técnica para DevOps

1. Creación de un repositorio con CI/CD
   
    ● Crea un repositorio en GitHub con un código básico (puede ser un servicio web
minimalista en cualquier lenguaje, por ejemplo, Node.js, Python, Go o cualquier
otro de tu preferencia).

● Configura un pipeline de CI/CD usando GitHub Actions. El pipeline debe incluir:

  1. Build: Compilar el código.
  2. Test: Ejecutar pruebas unitarias y enviar los resultados a Sonarqube.
  3. Deploy: Desplegar la aplicación en un clúster EKS en AWS.
  
  
  Requisitos:
    Estas Credenciales tiene duración de una semana <br>
            ● Aws Access Key ################## <br>
            ● Aws Secret Access Key  ################ <br>
            ● Cluster Name ################## <br>
            ● Sonar URL ################# <br>
            ● Sonar Token #######################
      
Si poseen un error en la comunicación o conexión deben describir el error y
proponer cuál es la configuración faltante para llevar a cabo el proceso

Desarrollo:

Se creó un repositorio con CI/CD configurado mediante un pipeline de GitHub Actions (ci-cd.yml). Las credenciales de AWS se registraron como secretos en el repositorio para asegurar que las conexiones con los servicios de AWS sean seguras. Sin embargo, encontré un problema al intentar desplegar el EKS (Elastic Kubernetes Service) en AWS: no tengo acceso al AWS directamente, lo que significa que no puedo interactuar con los recursos de la nube por mi cuenta. <br>

Para poder desplegar el EKS, unicamente necesitaría agregar mi usuario IAM a Kubernetes para obtener los permisos necesarios para conectarme al cluster y realizar tareas. Para sortear este "bloqueo", decidí tomar una solución temporal: creé un contenedor en Docker Hub y lo configuré para comprobar que el pipeline de GitHub Actions funcionaba correctamente. asi pude validar que el CI-CD fue configurado correctamente.

Una vez obtenga los accesos necesarios, se pueden modificar el pipeline para que apunte al cluster de AWS y desplegar el contenedor directamente en el EKS. por eso dejé una sección comentada en el archivo .yml, para que cuando tenga los permisos que se necesitan, solo sea cuestión de descomentar y ajustar lo necesario para que el pipeline se conecte al cluster de AWS y realice el despliegue de manera automática.


2. Generación de infraestructura con Terraform
   
  Crea un archivo de Terraform que cumpla con los siguientes requisitos:
  
      1. Infraestructura base:
        ○ Una red VPC configurada con subnets públicas y privadas.
        ○ Reglas de seguridad (Security Groups) necesarias.
        ○ Un Internet Gateway y NAT Gateway.
        
      2. Recursos principales:
        ○ Un clúster EKS con nodos configurados.
        ○ Una base de datos RDS (PostgreSQL o MySQL).
        ○ Opcional: DocumentDB o buckets S3. La elección debe depender de la
          variable project_type ("database" o "storage").

      3. Configuraciones adicionales:

        ○ Configurar IAM Roles y Policies necesarias para los servicios.
        ○ Proveer opciones escalables para los nodos del clúster.
        
Entrega: <br>
  ● Proporciona los archivos `.tf` necesarios para levantar esta infraestructura en
AWS.
  ● Asegúrate de incluir variables reutilizables para facilitar la personalización.


  Desarrollo: 


En el repositorio https://github.com/costellocesare/imaginamostest/tree/main/terraform, configuré los archivos `.tf` necesarios para crear la infraestructura base. Esta se creó en base a módulos separados:

VPC: Configuración de una red privada virtual, incluyendo subnets públicas y privadas, un Internet Gateway y un NAT Gateway. <br>
EKS: Creación de un clúster de Kubernetes administrado (Amazon EKS) con un grupo de nodos para la ejecución de aplicaciones. <br>
RDS: Configuración de una base de datos relacional administrada (Amazon RDS) para PostgreSQL. <br>
S3: Creación de un bucket de Amazon S3 opcional, según las necesidades del proyecto. <br><br>
Esta estructura permite que cada componente sea reutilizable y fácil de mantener. Además, configuré las variables necesarias para facilitar la personalización, como los IDs de subnets, roles de IAM y parámetros de bases de datos.

Una vez completada la configuración, se ejecutaron los siguientes comandos:


`terraform init`: Para inicializar el entorno de Terraform, descargando los proveedores necesarios y preparando los módulos. <br>

`terraform plan`: Para validar los archivos .tf y mostrar un resumen de los recursos que se crearían en AWS. <br>

`terraform apply`: Para aplicar los cambios y crear la infraestructura en AWS. <br>

El proceso de terraform apply falló debido a limitaciones de permisos en la cuenta de AWS configurada. Este detalle debe ser revisado antes de proceder con la implementación final.

3. Monitoreo centralizado de microservicios
   
  Diseña un proceso para monitorear los logs de múltiples microservicios distribuidos en varios clústeres EKS. Describe:
  
    1. Las herramientas seleccionadas y su configuración:
      ○ Logs: Propón una solución centralizada para recolectar y visualizar logs, por ejemplo, Loki con Grafana o Elasticsearch con Kibana.
      ○ Costos y eficiencia: Argumenta por qué estas herramientas son eficientes en términos de costo y escalabilidad.

    2. Proceso:
      ○ Cómo configuraste la recolección de logs desde los microservicios.
      ○ Cómo los desarrolladores pueden consultar fallos específicos en tiempo real.

    3. Opcional: Proponer métricas clave para medir la salud de los microservicios (uso de recursos, tiempos de respuesta, errores).

    Entrega:
      ● Documentación del proceso con diagramas si es necesario.
      ● Configuración y ejemplos de código para implementar esta solución.

      Desarrollo: 
Se entrega en el documento https://github.com/costellocesare/imaginamostest/blob/main/Monitoreo/Monitoreo%20centralizado%20de%20microservicios.pdf


Prueba finalizada.
