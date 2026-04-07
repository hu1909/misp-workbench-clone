FROM opensearchproject/opensearch:2.11.0

USER root

# Copy setup files
COPY mappings/ /usr/share/opensearch/setup/mappings/
COPY pipelines/ /usr/share/opensearch/setup/pipelines/
COPY index-templates/ /usr/share/opensearch/setup/index-templates/
COPY index-patterns/ /usr/share/opensearch/setup/index-patterns/
COPY visualizations/ /usr/share/opensearch/setup/visualizations/
COPY dashboards/ /usr/share/opensearch/setup/dashboards/
COPY setup-wrapper.sh /usr/share/opensearch/setup-wrapper.sh

RUN chmod +x /usr/share/opensearch/setup-wrapper.sh

# Switch back to opensearch user
USER opensearch

ENTRYPOINT ["/usr/share/opensearch/setup-wrapper.sh"]
